#!/usr/bin/env bash
# Phase 1 properties under independent clocks (multiclock on) at several widths: bmc, prove, cover.
# Deterministic table, full logs in results/evidence/c03v_a<N>_<task>.log. Cached when inputs unchanged.
# usage: ./c03_verify.sh      env: ADDRS="2 3 4 5" TASKS="bmc prove cover" SBY=... SVF="files" TIMEOUT=900
set -u
ADDRS=${ADDRS:-"2 3 4 5"}; TASKS=${TASKS:-"bmc prove cover"}
SBY=${SBY:-async_fifo_multiclock.sby}; SVF=${SVF:-"async_fifo.sv async_fifo_formal.sv"}
ROOT=$PWD; EVID=$ROOT/results/evidence; mkdir -p "$EVID"
for N in $ADDRS; do
  WD=c03_verify/addr_$N; rm -rf "$WD"; mkdir -p "$WD"; cp $SVF "$SBY" "$WD/"
  sed -i -E "s/(parameter[[:space:]]+ADDR_WIDTH[[:space:]]*=[[:space:]]*)[0-9]+/\1${N}/" "$WD"/*.sv
  for T in $TASKS; do
    ( cd "$WD" && EVID="$EVID" TIMEOUT="${TIMEOUT:-900}" "$ROOT/run_quiet.sh" "c03v_a${N}_$T" -- sby -f "$SBY" "$T" >/dev/null )
  done
done
echo "| width | task | status | secs |"; echo "|---|---|---|---|"
for N in $ADDRS; do for T in $TASKS; do
  read -r _ st _ secs < "$EVID/c03v_a${N}_$T.status" 2>/dev/null && echo "| $N | $T | $st | ${secs#secs=} |" || echo "| $N | $T | MISSING | |"
done; done
