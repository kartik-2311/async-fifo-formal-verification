#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
test "$(uname -o)" = GNU/Linux
case "$PWD" in /mnt/*) echo 'ABORT: run in the native Linux filesystem'; exit 1;; esac
exec python3 tools/run_all.py "$@"
