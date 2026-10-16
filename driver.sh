#!/usr/bin/env bash
# Runs each task in a FRESH claude session. Finished tasks are skipped, so it is resumable.
# Context can never run out across tasks because each task starts empty.
# Check flags on your version first: claude --help
# env: MAX_TURNS (30)  TRIES (2)  BUDGET (optional --max-budget-usd)  TOOLS
set -u
mkdir -p .done logs results
chmod +x ./*.sh checks/*.sh 2>/dev/null   # downloads often lose the executable bit
MAX_TURNS=${MAX_TURNS:-30}; TRIES=${TRIES:-2}
TOOLS=${TOOLS:-"Bash,Read,Edit,Write,Grep,Glob"}
for t in $(ls tasks/T*.md | sort); do
  id=$(basename "$t" .md)
  [ -f ".done/$id" ] && { echo "skip $id (done)"; continue; }
  ok=0
  for i in $(seq 1 "$TRIES"); do
    echo "== $id attempt $i  $(date +%T)"
    extra=""
    [ "$i" -gt 1 ] && extra=" NOTE: a previous attempt did not pass the acceptance check. Read STATE.md and any partial files, continue from there, do not restart."
    claude -p "$(cat "$t")$extra" --max-turns "$MAX_TURNS" --allowedTools "$TOOLS" \
      ${BUDGET:+--max-budget-usd "$BUDGET"} > "logs/$id.attempt$i.txt" 2>&1
    if grep -qE 'Invalid API key|authentication_error|OAuth token has expired|Please run /login|API Error: 401' "logs/$id.attempt$i.txt"; then
      echo "AUTH PROBLEM in logs/$id.attempt$i.txt. Fix credentials, then rerun ./driver.sh (it resumes)."; exit 3
    fi
    if [ -f "checks/$id.sh" ] && bash "checks/$id.sh" > "logs/$id.check.txt" 2>&1; then
      touch ".done/$id"; echo "$id done (attempt $i) $(date -u +%FT%TZ)" >> STATE.md; ok=1; break
    fi
  done
  if [ "$ok" -ne 1 ]; then
    echo "$id FAILED acceptance after $TRIES attempts. See logs/$id.*. Stopping."
    echo "$id FAILED $(date -u +%FT%TZ)" >> STATE.md; exit 1
  fi
done
echo "all tasks done"
