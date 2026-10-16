#!/usr/bin/env bash
# Run a command, keep the FULL output in a file, print only a short summary.
# usage: ./run_quiet.sh NAME -- command args...
# env:   TIMEOUT (seconds, default 1800)   EVID (default results/evidence)
set -u
NAME=${1:?usage: run_quiet.sh NAME -- command}; shift
[ "${1:-}" = "--" ] && shift
EVID=${EVID:-results/evidence}; mkdir -p "$EVID"
LOG="$EVID/$NAME.log"
START=$(date +%s)
timeout "${TIMEOUT:-1800}" "$@" > "$LOG" 2>&1
RC=$?
SECS=$(( $(date +%s) - START ))
if [ "$(basename "$1")" = "sby" ]; then
  case $RC in 0) ST=PASS;; 2) ST=FAIL;; 4) ST=UNKNOWN;; 8|124) ST=TIMEOUT;; 16) ST=ERROR;; *) ST="RC$RC";; esac
else
  case $RC in 0) ST=OK;; 124) ST=TIMEOUT;; *) ST="RC$RC";; esac
fi
echo "$NAME $ST rc=$RC secs=$SECS" > "$EVID/$NAME.status"
echo "[$NAME] $ST (rc=$RC, ${SECS}s) full log: $LOG ($(wc -l < "$LOG") lines)"
grep -E 'DONE \(|Assert failed|failed assertion|BMC failed|Reached cover|unreached|ERROR|error:|Temporal induction|returned (pass|FAIL)' "$LOG" | head -12
exit 0
