#!/usr/bin/env bash
# Runs each task in a FRESH claude session. Finished tasks are skipped, so it is resumable.
# Context can never run out across tasks because each task starts empty.
# Check flags on your version first: claude --help
# env: MAX_TURNS (25)  TRIES (2)  BUDGET (optional --max-budget-usd)  TOOLS  FRESH=1 (ignore existing outputs)
set -u
MAX_TURNS=${MAX_TURNS:-25}; TRIES=${TRIES:-2}
TOOLS=${TOOLS:-"Bash,Read,Edit,Write,Grep,Glob"}
# Best-effort deny list: stops sessions wandering off to install or build tools.
# preflight.sh makes one tiny claude call with these flags, so a wrong syntax is caught before any task runs.
# Disable with DENY="" ./driver.sh if your claude version rejects it.
DENY=${DENY-"Bash(pip:*),Bash(pip3:*),Bash(sudo:*),Bash(apt:*),Bash(apt-get:*),Bash(git clone:*),Bash(curl:*),Bash(wget:*),Bash(cmake:*),Bash(make:*),Bash(find /:*),Bash(rm:*)"}
export DENY
mkdir -p .done logs results
exec 9>.driver.lock
flock -n 9 || { echo "Another driver.sh is already running (lock: .driver.lock). Exiting so nothing runs twice."; exit 4; }
chmod +x ./*.sh checks/*.sh 2>/dev/null   # downloads often lose the executable bit
./preflight.sh || { echo "Preflight failed: no session started."; exit 5; }
for t in $(ls tasks/T*.md | sort); do
  id=$(basename "$t" .md)
  [ -f ".done/$id" ] && { echo "skip $id (done)"; continue; }
  # Already satisfied by existing outputs? Mark done without spending a session. FRESH=1 disables this.
  if [ -z "${FRESH:-}" ] && [ -f "checks/$id.sh" ] && bash "checks/$id.sh" >/dev/null 2>&1; then
    touch ".done/$id"; echo "$id already satisfied by existing outputs, marked done"
    echo "$id already satisfied $(date -u +%FT%TZ)" >> STATE.md; continue
  fi
  ok=0
  for i in $(seq 1 "$TRIES"); do
    echo "== $id attempt $i  $(date +%T)"
    extra=""
    [ "$i" -gt 1 ] && extra=" NOTE: a previous attempt did not pass the acceptance check. Read STATE.md and any partial files, continue from there, do not restart."
    claude -p "$(cat "$t")$extra" --max-turns "$MAX_TURNS" --allowedTools "$TOOLS" ${DENY:+--disallowedTools "$DENY"} \
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
