#!/usr/bin/env bash
test -s results/cleanup_report.md && test -f results/cleanup_manifest.csv && [ results/evidence/INDEX.txt -nt results/cleanup_manifest.csv ]
