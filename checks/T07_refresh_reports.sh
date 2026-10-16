#!/usr/bin/env bash
test -s results/process_report.md && test -s results/audit_report.md && grep -qi "open items" results/audit_report.md
