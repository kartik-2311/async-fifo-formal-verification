#!/usr/bin/env bash
# Run a command, keep the FULL output in a file, print only a short summary.
# usage: ./run_quiet.sh NAME -- command args...
# env:   TIMEOUT (seconds, default 1800)   EVID (default results/evidence)
#        DEPS  files the result depends on (default: *.sv *.sby in the current folder)
#        FORCE=1  rerun even if inputs are unchanged
# A run is CACHED (skipped) when command, TIMEOUT and DEPS content are identical to the last run.
set -u
NAME=${1:?usage: run_quiet.sh NAME -- command}; shift
[ "${1:-}" = "--" ] && shift
EVID=${EVID:-results/evidence}; mkdir -p "$EVID"
LOG="$EVID/$NAME.log"
DEPS=${DEPS:-$(ls ./*.sv ./*.sby 2>/dev/null | tr '\n' ' ')}
KEY=$( { echo "$*"; echo "TIMEOUT=${TIMEOUT:-1800}"; [ -n "$DEPS" ] && sha256sum $DEPS; } | sha256sum | cut -d' ' -f1)
if [ -z "${FORCE:-}" ] && [ -f "$EVID/$NAME.key" ] && [ -f "$EVID/$NAME.status" ] && [ "$(cat "$EVID/$NAME.key")" = "$KEY" ]; then
  echo "[$NAME] CACHED, inputs unchanged: $(cat "$EVID/$NAME.status")  (FORCE=1 to rerun)"
  grep -E 'DONE \(|Assert failed|failed assertion|BMC failed|Reached cover|unreached|ERROR|error:|Temporal induction|returned (pass|FAIL)' "$LOG" 2>/dev/null | head -12
  exit 0
fi
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
echo "$KEY" > "$EVID/$NAME.key"
echo "[$NAME] $ST (rc=$RC, ${SECS}s) full log: $LOG ($(wc -l < "$LOG") lines)"
grep -E 'DONE \(|Assert failed|failed assertion|BMC failed|Reached cover|unreached|ERROR|error:|Temporal induction|returned (pass|FAIL)' "$LOG" | head -12
exit 0
