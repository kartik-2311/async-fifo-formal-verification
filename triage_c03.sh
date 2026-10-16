#!/usr/bin/env bash
# Deterministic extraction for the Phase 1 multi-clock failure (C03). No LLM tokens needed.
# usage: ./triage_c03.sh "2 3 4 5"      -> writes results/triage_c03_extract.txt (short)
set -u
ADDRS=${1:-"2 3 4 5"}
OUT=results/triage_c03_extract.txt; mkdir -p results triage
{
  echo "# C03 triage extract  $(date -u +%FT%TZ)"
  echo "# files used (sha256):"; sha256sum async_fifo.sv async_fifo_formal.sv async_fifo_multiclock.sby
  echo "# git blobs:"; for f in async_fifo.sv async_fifo_formal.sv; do echo "$f $(git hash-object $f 2>/dev/null)"; done
} > "$OUT"
for N in $ADDRS; do
  WD="triage/addr_$N"; rm -rf "$WD"; mkdir -p "$WD"
  cp async_fifo.sv async_fifo_formal.sv async_fifo_multiclock.sby "$WD/"
  sed -i -E "s/(parameter[[:space:]]+ADDR_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${N}/" "$WD"/*.sv
  ( cd "$WD" && EVID=. TIMEOUT=300 ../../run_quiet.sh bmc -- sby -f async_fifo_multiclock.sby bmc >/dev/null )
  LOG="$WD/bmc.log"
  {
    echo; echo "## ADDR_WIDTH=$N  $(cat "$WD/bmc.status")"
    grep -E 'Assert failed|failed assertion|BMC failed' "$LOG" | sort -u | head -8
    for loc in $(grep -oE 'async_fifo_formal\.sv:[0-9]+' "$LOG" | sort -u | head -4); do
      f=${loc%%:*}; l=${loc##*:}; s=$(( l>6 ? l-6 : 1 ))
      echo "--- source $f around line $l ---"; awk -v s="$s" -v e="$((l+3))" 'NR>=s && NR<=e {printf "  %5d  %s\n", NR, $0}' "$WD/$f"
    done
    echo "trace: $(ls "$WD"/async_fifo_multiclock_bmc/engine_0/trace.vcd 2>/dev/null || echo none)"
  } >> "$OUT"
done
echo "wrote $OUT ($(wc -l < "$OUT") lines)"; head -c 4000 "$OUT"
