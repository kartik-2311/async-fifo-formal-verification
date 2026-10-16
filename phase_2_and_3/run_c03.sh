#!/usr/bin/env bash
# C03 triage: run multiclock BMC at ADDR_WIDTH 2-5 on the tracked formal source.
set -u
cd "$(dirname "$0")"

for N in 2 3 4 5; do
  WD="c03_work/addr_$N"
  rm -rf "$WD"
  mkdir -p "$WD"
  cp async_fifo.sv async_fifo_formal.sv async_fifo_multiclock.sby "$WD/"
  # Rewrite ADDR_WIDTH default in the copies only.
  sed -i -E "s/(parameter[[:space:]]+ADDR_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${N}/" "$WD"/*.sv
  echo "=== ADDR_WIDTH=$N ==="
  ( cd "$WD" && sby -f async_fifo_multiclock.sby bmc > bmc.log 2>&1 )
  echo "exit=$?"
  grep -E "failed assertion|Status:|DONE" "$WD/bmc.log" | head -5
done
echo "=== all done ==="
