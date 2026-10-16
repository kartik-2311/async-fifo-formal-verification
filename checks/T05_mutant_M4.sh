#!/usr/bin/env bash
test -s results/mutants/M4.md && grep -q 'caught by end-to-end property' results/mutants/M4.md
