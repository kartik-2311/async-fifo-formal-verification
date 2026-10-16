#!/usr/bin/env bash
# Task 2: More Phase 2 experiments - abc pdr (prove mode) and full depth.
set -u
cd "$(dirname "$0")"

N=2
DATA_W=1
D=20
WD="p2_feasibility/addr_${N}_dw${DATA_W}_d${D}"
TIMEOUT=600

run_abc_prove() {
  local sub="baseline_abc_prove"
  rm -rf "$WD/$sub"
  mkdir -p "$WD/$sub"
  cp async_fifo.sv async_fifo_integrity_top.sv async_fifo_integrity.sby "$WD/$sub/"
  sed -i -E "s/(parameter[[:space:]]+ADDR_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${N}/" "$WD/$sub"/*.sv
  sed -i -E "s/(parameter[[:space:]]+DATA_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${DATA_W}/" "$WD/$sub"/*.sv
  sed -i -E "s/(depth )[0-9]+/\1${D}/" "$WD/$sub"/*.sby
  # Use abc pdr in prove mode
  sed -i 's/smtbmc z3/abc pdr/' "$WD/$sub/async_fifo_integrity.sby"
  echo "=== baseline_abc_prove / abc pdr (prove mode) ==="
  START=$(date +%s)
  ( cd "$WD/$sub" && timeout "$TIMEOUT" sby -f async_fifo_integrity.sby prove > abc_prove.log 2>&1 )
  RC=$?
  END=$(date +%s)
  echo "  -> rc=$RC in $((END-START))s"
  grep -E "Status:|DONE|Timed out|ERROR|abc" "$WD/$sub/abc_prove.log" | tail -5
}

run_abc_prove

# Also try abc with bmc3 (bit-level BMC)
echo
echo "=== baseline_abc_bmc3 ==="
sub="baseline_abc_bmc3"
rm -rf "$WD/$sub"
mkdir -p "$WD/$sub"
cp async_fifo.sv async_fifo_integrity_top.sv async_fifo_integrity.sby "$WD/$sub/"
sed -i -E "s/(parameter[[:space:]]+ADDR_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${N}/" "$WD/$sub"/*.sv
sed -i -E "s/(parameter[[:space:]]+DATA_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${DATA_W}/" "$WD/$sub"/*.sv
sed -i -E "s/(depth )[0-9]+/\1${D}/" "$WD/$sub"/*.sby
sed -i 's/smtbmc z3/abc bmc3/' "$WD/$sub/async_fifo_integrity.sby"
START=$(date +%s)
( cd "$WD/$sub" && timeout "$TIMEOUT" sby -f async_fifo_integrity.sby bmc > abc_bmc3.log 2>&1 )
RC=$?
END=$(date +%s)
echo "  -> rc=$RC in $((END-START))s"
grep -E "Status:|DONE|Timed out|ERROR" "$WD/$sub/abc_bmc3.log" | tail -5
