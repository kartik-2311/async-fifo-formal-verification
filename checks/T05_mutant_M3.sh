#!/usr/bin/env bash
test -s results/mutants/M3.md && grep -q 'caught by end-to-end property' results/mutants/M3.md
