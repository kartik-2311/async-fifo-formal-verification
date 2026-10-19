#!/usr/bin/env bash
[ results/process_report.md -nt results/summary.json ] && [ results/audit_report.md -nt results/summary.json ] && grep -qi "open items" results/audit_report.md
