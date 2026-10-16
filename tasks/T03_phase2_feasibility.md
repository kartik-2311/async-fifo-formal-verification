Task T03: find a configuration where the Phase 2 integrity check finishes. Follow CLAUDE.md.
Phase 2 BMC and prove time out at 30 minutes even at ADDR_WIDTH=2. Work in a scratch copy
(triage/p2/). Use DATA_WIDTH=1 (the FIFO is data-independent; record this as an assumption).
Run each variant with TIMEOUT=900 through ./run_quiet.sh and read only its summary:
 a. ADDR_WIDTH=2, bmc, depth 32, engine `smtbmc z3`
 b. same with `smtbmc boolector` (only if boolector exists)
 c. same with `abc pdr` as the engine (prove mode)
 d. same as (a) with `smtbmc yices` (only if yices exists)
Edit parameters and engine lines only in the scratch copy, by sed. Never edit the real files.
Write results/phase2_feasibility.md: a table | variant | engine | ADDR | DATA | depth | status | secs |
with every row from a saved .status file, and 5 lines saying which variant to use going forward.
