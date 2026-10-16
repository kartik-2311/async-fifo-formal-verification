Task T02: act on results/C03_triage.md. Follow CLAUDE.md. Do only this task.
Read results/C03_triage.md (only that file for context).
- If the classification is `checker modeling`: apply the smallest fix to async_fifo_formal.sv
  WITHOUT weakening or deleting any assertion and without adding an assume. Save the diff to
  results/evidence/fix_c03.diff. Run ./collect_evidence.sh and confirm the assert count did not
  drop (results/evidence/assertion_counts.csv). Rerun with
  ./run_quiet.sh p1_mc_after_fix -- sby -f async_fifo_multiclock.sby   and read only its summary.
  If it still fails, repeat triage once with ./triage_c03.sh "2" and stop.
- Otherwise do not change any file.
Write results/C03_fix.md whose first line is exactly `STATUS: FIXED`, `STATUS: SKIPPED`
or `STATUS: BLOCKED`, followed by at most 20 lines of evidence with file paths.
