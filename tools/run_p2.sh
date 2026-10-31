#!/usr/bin/env bash
# run_p2.sh: run a formal harness on the original and on mutants.
# Usage: tools/run_p2.sh [NAME=rtl_path ...]     (default: CONTROL, M1, M2)
# Env:   W=2  DATA_WIDTH=8  MODES=single|multi  TMO=1800  BMC_ENGINE=abc|z3
#        EXPECTED_BMC=PASS|FAIL enables immediate per-task expectation gates.
#        HARN=<harness .sv>  (default: Phase 2 integrity harness; top module = file name)
set -euo pipefail
W=${W:-2}; MODES=${MODES:-single}; TMO=${TMO:-1800}
DATA_WIDTH=${DATA_WIDTH:-8}; BMC_ENGINE=${BMC_ENGINE:-abc}
EXPECTED_BMC=${EXPECTED_BMC:-}
case "$EXPECTED_BMC" in ''|PASS|FAIL) ;; *) echo "ABORT: EXPECTED_BMC must be PASS or FAIL"; exit 1 ;; esac
ROOT=$(cd "$(dirname "$0")/.." && pwd); cd "$ROOT" || exit 1
[[ $(uname -o) = GNU/Linux ]] || { echo "ABORT: GNU/Linux required"; exit 1; }
case "$ROOT" in /mnt/*) echo "ABORT: project is under /mnt"; exit 1;; esac
[[ $W =~ ^[2-5]$ ]] || { echo "ABORT: W must be 2-5"; exit 1; }
[[ $DATA_WIDTH =~ ^[1-9][0-9]{0,3}$ ]] && (( DATA_WIDTH <= 1024 )) || { echo "ABORT: invalid DATA_WIDTH"; exit 1; }
[[ $TMO =~ ^[1-9][0-9]{0,5}$ ]] || { echo "ABORT: invalid TMO"; exit 1; }
case "$BMC_ENGINE" in
  abc) ENGINE_LINE='abc bmc3'; command -v yosys-abc >/dev/null || { echo "ABORT: yosys-abc not found"; exit 1; } ;;
  z3) ENGINE_LINE='smtbmc z3' ;;
  *) echo "ABORT: BMC_ENGINE must be abc or z3"; exit 1 ;;
esac
for TOOL in sby yosys z3 python3 timeout nice; do
  command -v "$TOOL" >/dev/null || { echo "ABORT: $TOOL not found"; exit 1; }
done
HARN=${HARN:-$ROOT/mutants/control/async_fifo_integrity_top.sv}
[ -f "$HARN" ] || { echo "ABORT: harness not found: $HARN"; exit 1; }
TOP=$(basename "$HARN" .sv)
[[ $TOP =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || { echo "ABORT: invalid harness module name"; exit 1; }
if [ $# -gt 0 ]; then SPECS=("$@"); else
  SPECS=("CONTROL=async_fifo.sv" "M1=mutants/M1/async_fifo.sv" "M2=mutants/M2/async_fifo.sv"); fi
[[ $MODES != *$'\n'* && $MODES != *$'\r'* ]] || { echo "ABORT: clock modes must be on one line"; exit 1; }
read -r -a MODE_LIST <<< "$MODES"
declare -A SEEN_MODES=() SEEN_NAMES=()
for MODE in "${MODE_LIST[@]}"; do
  [[ $MODE = single || $MODE = multi ]] || { echo "ABORT: invalid mode: $MODE"; exit 1; }
  [[ ! -v SEEN_MODES[$MODE] ]] || { echo "ABORT: duplicate mode: $MODE"; exit 1; }
  SEEN_MODES[$MODE]=1
done
(( ${#MODE_LIST[@]} > 0 )) || { echo "ABORT: no clock modes"; exit 1; }
for SPEC in "${SPECS[@]}"; do
  DESIGN=${SPEC%%=*}
  [[ $SPEC = *=* && $DESIGN =~ ^[A-Za-z0-9_][A-Za-z0-9_-]*$ ]] || { echo "ABORT: invalid design specification"; exit 1; }
  [[ ! -v SEEN_NAMES[$DESIGN] ]] || { echo "ABORT: duplicate design: $DESIGN"; exit 1; }
  SEEN_NAMES[$DESIGN]=1
done
DEPTH=$(( (1 << (W + 2)) + 12 ))
mkdir -p "$ROOT/results"
OUT=$(mktemp -d "$ROOT/results/${TOP}_run_$(date +%m%d_%H%M%S)_XXXXXX")
CSV="$OUT/results.csv"
echo "design,mode,task,status,first_failure,seconds,width,depth,rtl,log,data_width,bmc_engine" > "$CSV"
append_row() {
  python3 - "$CSV" "$@" <<'PY'
import csv
import sys
with open(sys.argv[1], 'a', newline='') as stream:
    csv.writer(stream).writerow(sys.argv[2:])
PY
}
ACTIVE_TASK=''; BATCH_RC=0
interrupted() {
  trap - INT TERM
  if [[ -n $ACTIVE_TASK ]]; then
    append_row "$DESIGN" "$MODE" "$ACTIVE_TASK" UNKNOWN 'runner interrupted' "$((SECONDS-TASK_START))" "$W" "$DEPTH" "$RTL_PATH" "$TASK_DIR/$ACTIVE_TASK.log" "$DATA_WIDTH" "$ENGINE_LINE"
  fi
  exit 143
}
trap interrupted INT TERM
for SPEC in "${SPECS[@]}"; do
  DESIGN=${SPEC%%=*}; RTL_PATH=${SPEC#*=}
  if [[ ! -f $RTL_PATH ]]; then
    append_row "$DESIGN" - - NOT_RUN 'rtl not found' 0 "$W" "$DEPTH" "$RTL_PATH" - "$DATA_WIDTH" "$ENGINE_LINE"
    BATCH_RC=1
    continue
  fi
  for MODE in "${MODE_LIST[@]}"; do
    ML=off; [[ $MODE != multi ]] || ML=on
    TASK_DIR="$OUT/$DESIGN/$MODE"; mkdir -p "$TASK_DIR"
    python3 - "$RTL_PATH" "$HARN" "$TASK_DIR" "$TOP" "$W" "$DATA_WIDTH" <<'PY'
from pathlib import Path
import re
import sys
rtl, harness, destination, top, width, data_width = sys.argv[1:]
for source, filename in [(rtl, 'async_fifo.sv'), (harness, top + '.sv')]:
    text = Path(source).read_text(encoding='utf-8-sig')
    for parameter, value in [('ADDR_WIDTH', width), ('DATA_WIDTH', data_width)]:
        pattern = r'(\bparameter\s+(?:(?:int|integer)\s+)?' + parameter + r'\s*=\s*)\d+'
        text, count = re.subn(pattern, lambda match: match[1] + value, text)
        if not count:
            raise SystemExit('ABORT: missing integer parameter ' + parameter + ' in ' + source)
    with (Path(destination) / filename).open('x') as stream:
        stream.write(text)
PY
    cat > "$TASK_DIR/p2.sby" <<EOF2
[tasks]
bmc
cover

[options]
multiclock $ML
bmc: aigsmt z3
bmc: mode bmc
bmc: depth $DEPTH
cover: mode cover
cover: depth $DEPTH

[engines]
bmc: $ENGINE_LINE
cover: smtbmc z3

[script]
plugin -i slang
read_slang async_fifo.sv $TOP.sv --top $TOP
prep -top $TOP

[files]
async_fifo.sv
$TOP.sv
EOF2
    for TASK in bmc cover; do
      TASK_START=$SECONDS; ACTIVE_TASK=$TASK
      ( cd "$TASK_DIR" && TIMEOUT=$((TMO+60)) EVID="$TASK_DIR" DEPS="async_fifo.sv $TOP.sv p2.sby" "$ROOT/run_quiet.sh" "$TASK" -- timeout "$TMO" nice -n 10 sby -f p2.sby "$TASK" )
      SECS=$((SECONDS - TASK_START))
      RC=$(sed -n 's/.*rc=\([0-9]*\).*/\1/p' "$TASK_DIR/$TASK.status")
      TERMINAL=$(grep -oE 'DONE \((PASS|FAIL|UNKNOWN|ERROR|TIMEOUT), rc=[0-9]+\)' "$TASK_DIR/$TASK.log" | tail -n 1 | sed -E 's/DONE \(([A-Z]+), rc=([0-9]+)\)/\1:\2/' || true)
      STATUS=ERROR
      case "$RC:$TERMINAL" in
        124:*|8:TIMEOUT:8) STATUS=TIMEOUT ;;
        0:PASS:0) STATUS=PASS ;;
        2:FAIL:2) STATUS=FAIL ;;
        4:UNKNOWN:4) STATUS=UNKNOWN ;;
        16:ERROR:16) STATUS=ERROR ;;
      esac
      FIRST_FAILURE=$(grep -m1 -E 'Assert failed|Unreached cover' "$TASK_DIR/$TASK.log" | sed -E 's/.*(Assert failed|Unreached cover)/\1/' || true)
      if [[ $TASK = cover && $STATUS = PASS ]] && grep -q 'Unreached cover' "$TASK_DIR/$TASK.log"; then STATUS=FAIL; fi
      append_row "$DESIGN" "$MODE" "$TASK" "$STATUS" "${FIRST_FAILURE:--}" "$SECS" "$W" "$DEPTH" "$RTL_PATH" "$TASK_DIR/$TASK.log" "$DATA_WIDTH" "$ENGINE_LINE"
      ACTIVE_TASK=''
      case "$STATUS" in ERROR|TIMEOUT|UNKNOWN) BATCH_RC=1 ;; esac
      echo "$DESIGN $MODE $TASK -> $STATUS (${SECS}s)"
      if [[ -n $EXPECTED_BMC ]]; then
        EXPECTED=$EXPECTED_BMC
        [[ $TASK = bmc ]] || EXPECTED=PASS
        if [[ $STATUS != "$EXPECTED" ]]; then BATCH_RC=1; break 3; fi
      fi
    done
  done
done
echo; echo "RESULTS: $CSV"; cut -d, -f1-6 "$CSV"
exit "$BATCH_RC"
