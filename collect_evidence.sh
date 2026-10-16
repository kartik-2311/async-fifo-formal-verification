#!/usr/bin/env bash
# Mechanical evidence: versions, input hashes, assertion counts, full INDEX.txt. No LLM tokens.
# usage: SLANG_DIR=~/projects/yosys-slang ./collect_evidence.sh
set -u
E=results/evidence; mkdir -p "$E"
v() { if command -v "$1" >/dev/null 2>&1; then "$@" 2>&1 | head -1; else echo "not installed"; fi; }
{
  echo "date_utc: $(date -u +%FT%TZ)"
  echo "yosys: $(v yosys -V)"
  echo "z3: $(v z3 --version)"
  echo "sby: $(v sby --version)"
  [ -n "${SLANG_DIR:-}" ] && echo "yosys-slang: $(git -C "$SLANG_DIR" describe --always --dirty 2>/dev/null)"
  echo "boolector: $(v boolector --version)"
  echo "kernel: $(uname -srm)"; echo "cpus: $(nproc)"; echo "mem: $(free -h 2>/dev/null | awk '/Mem:/{print $2}')"
} > "$E/tool_versions.txt"
SRC=$(find . -maxdepth 4 -type f \( -name '*.sv' -o -name '*.sby' -o -name '*.sh' -o -name '*.py' \) \
      -not -path './results/*' -not -path './.git/*' -not -path '*_bmc/*' -not -path '*_prove/*' \
      -not -path '*_cover/*' -not -path './sweep_work/*' -not -path './triage/*' | sort)
( echo "sha256,path"; for f in $SRC; do echo "$(sha256sum "$f" | cut -d' ' -f1),$f"; done ) > "$E/input_hashes.csv"
( echo "file,assert,cover,assume,initial"
  for f in $(echo "$SRC" | grep '\.sv$'); do
    echo "$f,$(grep -cE '^[[:space:]]*assert[[:space:]]*\(' "$f"),$(grep -cE '^[[:space:]]*cover[[:space:]]*\(' "$f"),$(grep -cE '^[[:space:]]*assume[[:space:]]*\(' "$f"),$(grep -cE '^[[:space:]]*initial\b' "$f")"
  done ) > "$E/assertion_counts.csv"
# INDEX: hashes of results, mutants, sources, configs, reports (excluding INDEX itself)
{ find results mutants -type f ! -name INDEX.txt 2>/dev/null; echo "$SRC" | tr ' ' '\n'; } \
  | sed '/^$/d' | sort -u | while read -r f; do sha256sum "$f"; done > "$E/INDEX.txt"
echo "wrote tool_versions.txt, input_hashes.csv, assertion_counts.csv, INDEX.txt ($(wc -l < "$E/INDEX.txt") entries)"
