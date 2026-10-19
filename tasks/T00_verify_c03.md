Task T00: verify the claimed fix for C03 (Phase 1 failing under independent clocks) without trusting it.
Follow CLAUDE.md. Do only this task. If the fix already exists, mark T01 and T02 done afterwards:
touch .done/T01_c03_triage .done/T02_c03_fix
1. Find the fix. Run `git log --follow --oneline -- <path of async_fifo_formal.sv>`. Save the diff between the
   earliest commit of that file and the working copy to results/evidence/c03_fix.diff. Read only that diff.
   If the file was never committed before the fix, say so.
2. Classify every hunk. Allowed: how reset/history state is tracked. NOT allowed: removing or relaxing an assert,
   widening an assert's guard so it can never fire, adding an assume. Count asserts before and after, and list every
   assert whose enclosing condition changed, with the old and new condition.
3. Run ./c03_verify.sh (bmc, prove, cover at widths 2-5 under multiclock; prints a table). Do not read the logs.
4. Vacuity: python3 make_vacuity_copy.py async_fifo_formal.sv async_fifo_multiclock.sby   then run
   ./run_quiet.sh vac_a2 -- sby -f async_fifo_multiclock_vacuity.sby cover   (and again with ADDR_WIDTH=4 in a
   scratch copy). Every inserted cover must be reached. List any that is not.
5. Write results/C03_verification.md (max 40 lines) with: the diff classification, the table from step 3, the
   vacuity result, and a line exactly like `Decision: VERIFIED` or `Decision: NOT VERIFIED` or `Decision: FAILED`.
   VERIFIED requires bmc AND prove AND cover to pass at every width, an acceptable diff, and no unreached cover.
