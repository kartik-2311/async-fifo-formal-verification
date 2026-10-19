#!/usr/bin/env bash
# Fail fast, BEFORE any LLM tokens are spent. exit 0 = ready, exit 5 = not ready.
# env: SKIP_CLAUDE=1 skips the one-word claude test call.  DENY = deny list to validate.
set -u
fail=0; bad() { echo "PREFLIGHT FAIL: $*"; fail=1; }
OS=${FAKE_UNAME:-$(uname -o 2>/dev/null || uname -s)}
case "$OS" in
  Msys*|Cygwin*|MINGW*) bad "this shell is Git Bash/MSYS ($OS), not Linux. yosys, sby and z3 live in WSL. Open a WSL terminal, cd to the project there, and run claude there." ;;
esac
for c in bash git python3 flock yosys sby z3; do command -v "$c" >/dev/null 2>&1 || bad "'$c' is not on PATH"; done
if command -v sby >/dev/null 2>&1; then
  p=$(command -v sby)
  case "$p" in *[Mm][Oo][Cc][Kk]*|*[Ss][Tt][Uu][Bb]*) bad "sby resolves to a mock or stub ($p). Real runs need the real SymbiYosys." ;; esac
  sby --help >/dev/null 2>&1 || bad "'sby --help' fails"
fi
if command -v yosys >/dev/null 2>&1; then
  yosys -p "plugin -i slang" >/dev/null 2>&1 || bad "yosys cannot load the slang plugin ('plugin -i slang')"
fi
case "$PWD" in /mnt/[a-z]/*) echo "warning: project is on the Windows drive ($PWD): slow file I/O and CRLF risk. Consider copying it to ~/projects." ;; esac
for f in ./*.sh checks/*.sh; do
  [ -f "$f" ] && grep -q $'\r' "$f" && echo "warning: $f has CRLF line endings. Fix: sed -i 's/\r\$//' $f"
done
if [ -z "${SKIP_CLAUDE:-}" ]; then
  if command -v claude >/dev/null 2>&1; then
    out=$(timeout 180 claude -p "Reply with the single word ok" --max-turns 1 ${DENY:+--disallowedTools "$DENY"} 2>&1)
    echo "$out" | grep -qiw "ok" || bad "claude test call failed or flags were rejected: $(echo "$out" | head -c 300)"
  else
    bad "'claude' is not on PATH in this shell"
  fi
fi
[ "$fail" -eq 0 ] && echo "preflight OK" || echo "preflight FAILED: fix the above, then rerun. No session was started."
exit $(( fail ? 5 : 0 ))