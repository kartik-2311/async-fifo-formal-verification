Task T04: unmutated control for the mutation tests. Follow CLAUDE.md.
Create mutants/control/ as an exact copy of async_fifo.sv, async_fifo_formal.sv,
async_fifo_integrity_top.sv and the sby files (copies only). In that folder set
ADDR_WIDTH=2 and DATA_WIDTH=1 with sed and use bmc depth 32 (do not change the properties).
Run, with TIMEOUT=900 and from inside mutants/control (EVID=../../results/evidence):
 ../../run_quiet.sh mut_control_p1bmc -- sby -f async_fifo_multiclock.sby bmc
 ../../run_quiet.sh mut_control_p2bmc -- sby -f async_fifo_integrity.sby bmc
Write results/mutants/control.md: the commands, the two statuses and seconds (from .status files),
and the exact config used. If the control does not PASS, say so plainly. That would invalidate the
mutation results.
