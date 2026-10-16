#!/usr/bin/env bash
# Phase 3 parameter sweep.
# Re-runs the proof sets at several FIFO depths and records status + wall time.
#
# Run from the folder holding async_fifo.sv, async_fifo_formal.sv,
# async_fifo_integrity_top.sv and the .sby files:
#     chmod +x sweep.sh && ./sweep.sh
#
# Overrides (all optional), e.g.:
#     ADDRS="2 3" TIMEOUT=600 ./sweep.sh
#     TASKS="bmc cover" ./sweep.sh
#     DATA_W=4 ./sweep.sh        # narrower data path = faster (FIFO is data-independent)

set -u

ADDRS=${ADDRS:-"2 3 4 5"}                     # ADDR_WIDTH values; depth = 2**ADDR_WIDTH
DATA_W=${DATA_W:-8}
TIMEOUT=${TIMEOUT:-1800}                      # seconds per run
TASKS=${TASKS:-"bmc prove cover"}
SBY_FILES=${SBY_FILES:-"async_fifo_multiclock.sby async_fifo_integrity.sby"}
SV_FILES=${SV_FILES:-"async_fifo.sv async_fifo_formal.sv async_fifo_integrity_top.sv"}
WORK=sweep_work
OUT=sweep_results.csv

mkdir -p "$WORK"

{
  echo "# date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "# yosys: $(yosys -V 2>&1 | head -1)"
  echo "# z3: $(z3 --version 2>&1 | head -1)"
  echo "# data_width: $DATA_W  timeout_s: $TIMEOUT"
  echo "addr_width,entries,bmc_depth,sby_file,task,status,seconds"
} > "$OUT"

for N in $ADDRS; do
  ENTRIES=$((1 << N))
  # Deep enough to push the highest tag index (2**(N+1)-1) through write,
  # 2-flop sync and read.
  D=$(( (1 << (N + 1)) + 12 ))
  WD="$WORK/addr_$N"
  rm -rf "$WD"
  mkdir -p "$WD"

  for f in $SV_FILES $SBY_FILES; do
    if [ ! -f "$f" ]; then
      echo "missing file: $f (run from the project folder)" >&2
      exit 1
    fi
    cp "$f" "$WD/"
  done

  # Rewrite parameter defaults in the copies only; originals stay untouched.
  sed -i -E "s/(parameter[[:space:]]+ADDR_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${N}/" "$WD"/*.sv
  sed -i -E "s/(parameter[[:space:]]+DATA_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${DATA_W}/" "$WD"/*.sv
  sed -i -E "s/(depth )[0-9]+/\1${D}/" "$WD"/*.sby

  for SBY in $SBY_FILES; do
    for T in $TASKS; do
      echo ">>> ADDR_WIDTH=$N ($ENTRIES entries)  depth=$D  $SBY  $T"
      START=$(date +%s)
      ( cd "$WD" && timeout "$TIMEOUT" sby -f "$SBY" "$T" > "log_${SBY%.sby}_${T}.txt" 2>&1 )
      RC=$?
      END=$(date +%s)
      case $RC in
        0)   STATUS=PASS ;;
        2)   STATUS=FAIL ;;
        4)   STATUS=UNKNOWN ;;
        8)   STATUS=TIMEOUT ;;
        16)  STATUS=ERROR ;;
        124) STATUS=TIMEOUT ;;
        *)   STATUS="RC$RC" ;;
      esac
      echo "$N,$ENTRIES,$D,$SBY,$T,$STATUS,$((END - START))" >> "$OUT"
      echo "    -> $STATUS in $((END - START))s"
    done
  done
done

echo
echo "Results written to $OUT"
grep -v '^#' "$OUT" | column -s, -t
