Task T06: reconcile results/summary.json. Follow CLAUDE.md. Do only this task.
1. Run ./collect_evidence.sh (mechanical; prints one line).
2. Read results/C03_triage.md, results/C03_fix.md, results/phase2_feasibility.md and results/mutants/*.md.
3. Update results/summary.json (edit with python, do not retype it):
   - add C03's classification and fix status; add C03 to open_items if it is not STATUS: FIXED
   - add the mutation control row and each mutant's failing-assertion labels
   - add the phase 2 feasibility outcome
   - rename original_phase2 to pre_audit_phase2
   - state which harness version produced the sweep rows: compare results/evidence/input_hashes.csv with
     sha256sum of sweep_work/addr_*/async_fifo_integrity_top.sv. Fix the stale "sweep underway" text
   - add the tool versions from results/evidence/tool_versions.txt (key: tool_versions)
4. Rerun ./collect_evidence.sh so INDEX.txt covers the new files.
Do not change any claim status to VERIFIED unless a saved log shows it.
