Task T05-M2: mutation test. Follow CLAUDE.md. Do only this mutant.
Mutation: remove the ~rd_empty gating on the read pointer increment.
1. Create mutants/M2/ with copies of async_fifo.sv, async_fifo_formal.sv, async_fifo_integrity_top.sv
   and both sby files. Same settings as mutants/control (read results/mutants/control.md): ADDR_WIDTH=2,
   DATA_WIDTH=1, same depth. Apply the mutation ONLY to mutants/M2/async_fifo.sv.
2. Save the diff: diff -u async_fifo.sv mutants/M2/async_fifo.sv > results/evidence/mut_M2.diff
3. Run Phase 1 bmc and Phase 2 bmc through ../../run_quiet.sh from inside mutants/M2 with
   EVID=../../results/evidence (names mut_M2_p1bmc and mut_M2_p2bmc, TIMEOUT=900).
4. From each log, list EVERY failing assertion (grep 'Assert failed', with file:line). For each, look at
   the nearby comment tag and label it P2a / P2b / P2c (end-to-end) or helper (internal invariant).
5. Write results/mutants/M2.md: the mutation, statuses and seconds, the list of failing assertions with
   labels, and the lines "caught by end-to-end property: yes/no" and "caught by helper only: yes/no".
