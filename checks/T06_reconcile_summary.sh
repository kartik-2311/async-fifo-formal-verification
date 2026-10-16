#!/usr/bin/env bash
python3 -c "import json;s=json.dumps(json.load(open(\"results/summary.json\")));assert \"pre_audit_phase2\" in s and \"tool_versions\" in s" && test -s results/evidence/INDEX.txt
