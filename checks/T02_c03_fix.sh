#!/usr/bin/env bash
head -1 results/C03_fix.md | grep -qE "^STATUS: (FIXED|SKIPPED|BLOCKED)"
