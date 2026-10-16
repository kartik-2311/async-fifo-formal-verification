#!/usr/bin/env bash
# Task 2: Phase 2 feasibility experiments.
# Compares baseline (with helper invariants) vs no-helper, and different engines.
set -u
cd "$(dirname "$0")"

N=2
DATA_W=1
D=20  # shorter depth for quick comparison; full sweep depth is 32
WD="p2_feasibility/addr_${N}_dw${DATA_W}_d${D}"
TIMEOUT=600  # 10 min per run

rm -rf "$WD"
mkdir -p "$WD"

setup_dir() {
  local sub="$1"
  local topfile="$2"
  local sbyfile="$3"
  rm -rf "$WD/$sub"
  mkdir -p "$WD/$sub"
  cp async_fifo.sv "$topfile" "$sbyfile" "$WD/$sub/"
  sed -i -E "s/(parameter[[:space:]]+ADDR_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${N}/" "$WD/$sub"/*.sv
  sed -i -E "s/(parameter[[:space:]]+DATA_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${DATA_W}/" "$WD/$sub"/*.sv
  sed -i -E "s/(depth )[0-9]+/\1${D}/" "$WD/$sub"/*.sby
}

run_one() {
  local sub="$1"
  local sbyfile="$2"
  local engine="$3"
  local logname="$4"
  echo "=== $sub / $engine ==="
  START=$(date +%s)
  ( cd "$WD/$sub" && timeout "$TIMEOUT" sby -f "$sbyfile" bmc > "${logname}.log" 2>&1 )
  RC=$?
  END=$(date +%s)
  local elapsed=$((END - START))
  case $RC in
    0)   STATUS=PASS ;;
    2)   STATUS=FAIL ;;
    4)   STATUS=UNKNOWN ;;
    8)   STATUS=TIMEOUT ;;
    16)  STATUS=ERROR ;;
    124) STATUS=TIMEOUT ;;
    *)   STATUS="RC$RC" ;;
  esac
  echo "  -> $STATUS in ${elapsed}s (rc=$RC)"
  grep -E "Status:|DONE|Timed out|ERROR" "$WD/$sub/${logname}.log" | tail -2
  echo "$sub,$engine,$STATUS,$elapsed" >> "$WD/results.csv"
}

echo "config,engine,status,seconds" > "$WD/results.csv"

# 1. Baseline (helper invariants ON) with z3
setup_dir "baseline_z3" async_fifo_integrity_top.sv async_fifo_integrity.sby
run_one "baseline_z3" async_fifo_integrity.sby "smtbmc z3" "bmc_z3"

# 2. No-helper invariants with z3
setup_dir "nohelper_z3" async_fifo_integrity_top_nohelper.sv async_fifo_integrity.sby
# Patch the sby to use the no-helper top and define the macro
sed -i 's/async_fifo_integrity_top\.sv/async_fifo_integrity_top_nohelper.sv/' "$WD/nohelper_z3/async_fifo_integrity.sby"
sed -i 's/read_slang async_fifo.sv async_fifo_integrity_top_nohelper.sv/read_slang async_fifo.sv async_fifo_integrity_top_nohelper.sv +define+NO_HELPER_INVARIANTS/' "$WD/nohelper_z3/async_fifo_integrity.sby"
run_one "nohelper_z3" async_fifo_integrity.sby "smtbmc z3" "bmc_z3"

# 3. Baseline with boolector
setup_dir "baseline_btor" async_fifo_integrity_top.sv async_fifo_integrity.sby
sed -i 's/smtbmc z3/smtbmc boolector/' "$WD/baseline_btor/async_fifo_integrity.sby"
run_one "baseline_btor" async_fifo_integrity.sby "smtbmc boolector" "bmc_btor"

# 4. Baseline with abc pdr
setup_dir "baseline_abc" async_fifo_integrity_top.sv async_fifo_integrity.sby
sed -i 's/smtbmc z3/abc pdr/' "$WD/baseline_abc/async_fifo_integrity.sby"
run_one "baseline_abc" async_fifo_integrity.sby "abc pdr" "bmc_abc"

echo
echo "=== RESULTS (depth=$D) ==="
cat "$WD/results.csv"
