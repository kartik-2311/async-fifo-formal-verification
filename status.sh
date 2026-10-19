#!/usr/bin/env bash
# Compact status (about 15 lines), cheap to call repeatedly.  usage: ./status.sh [--wait SECONDS]
# --wait returns as soon as a task finishes, the driver stops, or the time runs out.
set -u
running() { ! flock -n .driver.lock true 2>/dev/null; }
count() { ls .done 2>/dev/null | wc -l; }
if [ "${1:-}" = "--wait" ]; then
  end=$(( $(date +%s) + ${2:-540} )); d0=$(count)
  while running && [ "$(date +%s)" -lt "$end" ] && [ "$(count)" = "$d0" ]; do sleep 15; done
fi
total=$(ls tasks/T*.md 2>/dev/null | wc -l)
echo "tasks done: $(count)/$total   driver: $(running && echo RUNNING || echo stopped)"
echo "done: $(ls .done 2>/dev/null | tr '\n' ' ')"
next=""; for t in $(ls tasks/T*.md 2>/dev/null | sort); do id=$(basename "$t" .md); [ -f ".done/$id" ] || { next=$id; break; }; done
[ -n "$next" ] && echo "current/next: $next" || echo "ALL TASKS DONE"
echo "--- STATE.md (last 4) ---"; tail -n 4 STATE.md 2>/dev/null
echo "--- driver.out (last 5) ---"; tail -n 5 driver.out 2>/dev/null
if ! running && [ -n "$next" ]; then
  if grep -q "AUTH PROBLEM" driver.out 2>/dev/null; then echo "HINT: authentication problem. Fix the login or key, then ./driver.sh resumes."
  elif grep -q "Preflight failed" driver.out 2>/dev/null; then echo "HINT: preflight failed. Run ./preflight.sh and fix what it prints."
  elif grep -q "FAILED acceptance" driver.out 2>/dev/null; then echo "HINT: a task failed its check twice. See logs/$next.check.txt and the attempt log."
  else echo "HINT: driver stopped before finishing. Rerun ./bootstrap.sh --start (it resumes)."; fi
fi
exit 0
