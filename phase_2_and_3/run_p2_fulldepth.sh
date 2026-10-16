#!/usr/bin/env bash
# Task 2: Full-depth experiments with abc pdr and abc bmc3.
set -u
cd "$(dirname "$0")"

N=2
DATA_W=1
D=32  # full sweep depth
WD="p2_feasibility/addr_${N}_dw${DATA_W}_d${D}"
TIMEOUT=1800

mkdir -p "$WD"

setup() {
  local sub="$1"
  local topfile="$2"
  rm -rf "$WD/$sub"
  mkdir -p "$WD/$sub"
  cp async_fifo.sv "$topfile" async_fifo_integrity.sby "$WD/$sub/"
  sed -i -E "s/(parameter[[:space:]]+ADDR_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${N}/" "$WD/$sub"/*.sv
  sed -i -E "s/(parameter[[:space:]]+DATA_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${DATA_W}/" "$WD/$sub"/*.sv
  sed -i -E "s/(depth )[0-9]+/\1${D}/" "$WD/$sub"/*.sby
}

run() {
  local sub="$1"
  local engine="$2"
  local task="$3"
  local logname="$4"
  echo "=== $sub / $engine / $task (depth=$D) ==="
  START=$(date +%s)
  ( cd "$WD/$sub" && timeout "$TIMEOUT" sby -f async_fifo_integrity.sby "$task" > "${logname}.log" 2>&1 )
  RC=$?
  END=$(date +%s)
  case $RC in
    0) STATUS=PASS ;; 2) STATUS=FAIL ;; 4) STATUS=UNKNOWN ;;
    8) STATUS=TIMEOUT ;; 16) STATUS=ERROR ;; 124) STATUS=TIMEOUT ;;
    *) STATUS="RC$RC" ;;
  esac
  echo "  -> $STATUS in $((END-START))s (rc=$RC)"
  grep -E "Status:|DONE|Timed out|ERROR|returned" "$WD/$sub/${logname}.log" | tail -3
  echo "$sub,$engine,$task,$STATUS,$((END-START))" >> "$WD/results.csv"
}

echo "config,engine,task,status,seconds" > "$WD/results.csv"

# 1. Baseline + abc pdr (prove) at depth 32
setup "baseline_abc_pdr" async_fifo_integrity_top.sv
sed -i 's/smtbmc z3/abc pdr/' "$WD/baseline_abc_pdr/async_fifo_integrity.sby"
run "baseline_abc_pdr" "abc pdr" "prove" "abc_pdr"

# 2. Baseline + abc bmc3 at depth 32
setup "baseline_abc_bmc3" async_fifo_integrity_top.sv
sed -i 's/smtbmc z3/abc bmc3/' "$WD/baseline_abc_bmc3/async_fifo_integrity.sby"
run "baseline_abc_bmc3" "abc bmc3" "bmc" "abc_bmc3"

# 3. No-helper + abc pdr (prove) at depth 32
setup "nohelper_abc_pdr" async_fifo_integrity_top_nohelper.sv
sed -i 's/async_fifo_integrity_top\.sv/async_fifo_integrity_top_nohelper.sv/' "$WD/nohelper_abc_pdr/async_fifo_integrity.sby"
sed -i 's/read_slang async_fifo.sv async_fifo_integrity_top_nohelper.sv/read_slang async_fifo.sv async_fifo_integrity_top_nohelper.sv +define+NO_HELPER_INVARIANTS/' "$WD/nohelper_abc_pdr/async_fifo_integrity.sby"
sed -i 's/smtbmc z3/abc pdr/' "$WD/nohelper_abc_pdr/async_fifo_integrity.sby"
run "nohelper_abc_pdr" "abc pdr" "prove" "abc_pdr"

# 4. No-helper + abc bmc3 at depth 32
setup "nohelper_abc_bmc3" async_fifo_integrity_top_nohelper.sv
sed -i 's/async_fifo_integrity_top\.sv/async_fifo_integrity_top_nohelper.sv/' "$WD/nohelper_abc_bmc3/async_fifo_integrity.sby"
sed -i 's/read_slang async_fifo.sv async_fifo_integrity_top_nohelper.sv/read_slang async_fifo.sv async_fifo_integrity_top_nohelper.sv +define+NO_HELPER_INVARIANTS/' "$WD/nohelper_abc_bmc3/async_fifo_integrity.sby"
sed -i 's/smtbmc z3/abc bmc3/' "$WD/nohelper_abc_bmc3/async_fifo_integrity.sby"
run "nohelper_abc_bmc3" "abc bmc3" "bmc" "abc_bmc3"

echo
echo "=== RESULTS (depth=$D) ==="
cat "$WD/results.csv"
