#!/usr/bin/env bash
# One-shot, deterministic setup and launch. No LLM needed.  usage: ./bootstrap.sh [--start]
# Run it from WSL, inside the project folder (the one containing CLAUDE.md, driver.sh, tasks/).
set -u
EXPECT_BLOB=${EXPECT_BLOB:-c7daaf2a4f5d6e5036ac5faf5072bf4966eb7f0f}   # git blob of the ORIGINAL async_fifo.sv (CRLF-normalised)
[ -f driver.sh ] && [ -d tasks ] || { echo "Run this inside the kit folder (driver.sh and tasks/ not found here: $PWD)."; exit 2; }
chmod +x ./*.sh ./*.py checks/*.sh 2>/dev/null
echo "== 1. location: $PWD"
case "$PWD" in /mnt/[a-z]/*) echo "warning: on the Windows drive. Slow I/O and CRLF risk; prefer a copy under ~/projects." ;; esac

echo "== 2. is the real RTL untouched?"
bad=0
for f in rtl/async_fifo.sv async_fifo.sv; do
  [ -f "$f" ] || continue
  h=$(tr -d '\r' < "$f" | git hash-object --stdin 2>/dev/null)
  if [ "$h" = "$EXPECT_BLOB" ]; then echo "  OK       $f matches the original"
  else echo "  WARNING  $f differs from the original (blob $h). Inspect: git diff --stat -- $f"; bad=1; fi
done
[ "$bad" = 1 ] && echo "  If that file is a deliberate copy (for example in a mutant folder) this is expected; the real one must be OK."

echo "== 3. invalid evidence from runs where a tool was missing (rc 126/127)"
n=0
for s in results/evidence/*.status; do
  [ -f "$s" ] || continue
  read -r name st _ < "$s"
  case "$st" in RC127|RC126)
    echo "  removing $name ($st): not real evidence"; rm -f "results/evidence/$name.log" "results/evidence/$name.status" "results/evidence/$name.key"; n=$((n+1)) ;;
  esac
done
[ "$n" = 0 ] && echo "  none"
if [ -d mutants/control/results ]; then
  if grep -qL 'RC127' mutants/control/results/evidence/*.status 2>/dev/null || ! ls mutants/control/results/evidence/*.status >/dev/null 2>&1; then
    echo "  stray folder mutants/control/results holds more than failed-run logs: left alone, please inspect"
  else rm -rf mutants/control/results; echo "  removed stray mutants/control/results (only failed-run logs)"; fi
fi
if [ -d yosys/.git ] && [ -d yosys/kernel ] && ! git ls-files --error-unmatch yosys >/dev/null 2>&1; then
  echo "  NOTE stray yosys source clone: yosys/ ($(du -sh yosys 2>/dev/null | cut -f1)). Not deleted automatically."
  echo "       If you did not put it there on purpose: rm -rf yosys"
fi

echo "== 4. preflight"
./preflight.sh || { echo "Fix the preflight failures above first. Nothing was started."; exit 5; }

if [ "${1:-}" = "--start" ]; then
  if flock -n .driver.lock true 2>/dev/null; then
    nohup ./driver.sh > driver.out 2>&1 &
    echo "== driver started (pid $!). Monitor with: ./status.sh --wait 540"
  else echo "== a driver is already running. Monitor with: ./status.sh"; fi
else echo "== checks done. Start with: ./bootstrap.sh --start"; fi
