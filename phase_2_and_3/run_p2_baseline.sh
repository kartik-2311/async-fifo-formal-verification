#!/usr/bin/env bash
# Task 2: Phase 2 feasibility experiments.
# Runs integrity BMC at ADDR_WIDTH=2, DATA_WIDTH=1 with various configurations.
set -u
cd "$(dirname "$0")"

N=2
DATA_W=1
D=32  # (1 << (2+2)) + 12 = 28, min 32
WD="p2_feasibility/addr_${N}_dw${DATA_W}"

rm -rf "$WD"
mkdir -p "$WD"

# Baseline: original integrity harness
cp async_fifo.sv async_fifo_integrity_top.sv async_fifo_integrity.sby "$WD/"
sed -i -E "s/(parameter[[:space:]]+ADDR_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${N}/" "$WD"/*.sv
sed -i -E "s/(parameter[[:space:]]+DATA_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${DATA_W}/" "$WD"/*.sv
sed -i -E "s/(depth )[0-9]+/\1${D}/" "$WD"/*.sby

echo "=== BASELINE: integrity bmc, ADDR_WIDTH=$N DATA_WIDTH=$DATA_W depth=$D ==="
START=$(date +%s)
( cd "$WD" && sby -f async_fifo_integrity.sby bmc > bmc_baseline.log 2>&1 )
RC=$?
END=$(date +%s)
echo "exit=$RC  time=$((END-START))s"
grep -E "Status:|DONE|Timed out" "$WD/bmc_baseline.log" | tail -3
