Task T01: triage why the Phase 1 properties fail under `multiclock on` (claim C03).
Follow CLAUDE.md. Do only this task.
1. Run: ./triage_c03.sh "2 3 4 5"   (deterministic; prints a short extract).
2. Read ONLY results/triage_c03_extract.txt. Do not open VCDs or logs.
3. Check that the files used hash to the tracked ones: `git ls-files -s formal/async_fifo_formal.sv`
   versus the hashes at the top of the extract. Say if they differ.
4. Write results/C03_triage.md (max 40 lines) with: failing assertion name and file:line;
   failing step; a plain reading of what the trace must be doing; and a line exactly like
   `Classification: RTL bug` or `Classification: checker modeling` or `Classification: tool artifact`;
   then one paragraph of reasoning and a proposed fix (do NOT apply it).
If it looks like an RTL bug, say so in the file and stop.
