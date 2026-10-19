Task T08: remove unnecessary, unwanted and duplicate files, safely. Follow CLAUDE.md. Do only this task.
You do NOT choose what to delete. cleanup.py decides by fixed rules and never touches tracked files,
sources, configs, results/, mutants/, sweep_work/, or anything cited in summary.json, the reports or INDEX.txt.
1. Run: python3 cleanup.py            (dry run; prints counts and a short list, writes results/cleanup_candidates.csv)
2. Read ONLY that short output. If any candidate looks like evidence, a source or a config, do not apply.
   Write the reason in results/cleanup_report.md and stop.
3. Otherwise run: python3 cleanup.py --apply   (moves candidates into .trash/<timestamp>/, writes results/cleanup_manifest.csv)
4. Run ./collect_evidence.sh so INDEX.txt matches the cleaned tree.
5. Write results/cleanup_report.md (max 20 lines): counts per category, total size moved, the REVIEW duplicate
   groups that need a human decision, and the restore command (python3 cleanup.py --restore <timestamp>).
Never run --purge. Never run rm. The user decides about .trash/.
