#!/usr/bin/env bash
test -s results/mutants/M5.md && grep -q 'caught by end-to-end property' results/mutants/M5.md
