# Phase 2 and 3 Results

> Historical results note: this file is a prior Phase 2/3 summary and is
> superseded by the current independent audit in
> [audit_report.md](./audit_report.md) and
> [process_report.md](./process_report.md). In particular, the active Phase 2
> harness is the F6 revision; later F7/F8 helper assertions were experimental,
> failed induction, and were excluded from the final source. Consult the
> claims ledger and saved evidence before reusing any result below.

## Scope and RTL status

The DUT copy in this phase was not modified. The Phase 0/1 source and
configurations were not edited. Mutations were run in isolated copies under
`mutants/`.

## Toolchain

| Tool | Version |
|---|---|
| Yosys | 0.69+20 (git sha1 3a8289484) |
| SymbiYosys | 0.69 |
| Z3 | 4.13.3, 64-bit |
| Python | 3.14.4 |
| matplotlib | 3.11.2 |

## Phase 1 clock-model evidence and rerun

The default generated preparation scripts in `formal/async_fifo_{bmc,prove,cover}/model/design_prep.ys`
contain `async2sync` and `formalff -setundef -clk2ff`. They do not contain
`clk2fflogic`. This is a converted, single-global-step model, not evidence of
independent-clock CDC behavior. The multiclock SBY configuration enables
`multiclock on`.

| Command | Result |
|---|---|
| `sby -f async_fifo_multiclock.sby bmc` | FAIL at `async_fifo_formal.sv:131`, step 9 |
| `sby -f async_fifo_multiclock.sby prove` | FAIL in base case at the same assertion |
| `sby -f async_fifo_multiclock.sby cover` | PASS; all three Phase 1 cover statements reached |

The BMC trace is a checker/model failure rather than a confirmed RTL defect:
with independent clocks, the Phase 1 read-empty formula assertion compares
state from independently reset/synchronized domains without an established
cross-domain relation. No Phase 1 property or source was changed.

## Phase 2 properties and assumptions

The harness checks:

* **P2a:** accepted writes cannot exceed scoreboard capacity.
* **P2b:** accepted reads cannot occur with an empty scoreboard.
* **P2c:** the tagged sequence item is written before it is read and its data
  matches at read time.
* **P2d:** `wr_full_next` equals the intended Gray-pointer full comparison.
* Helper assertions relate the scoreboard counters to DUT binary pointers,
  binary and Gray pointers, occupancy, and the tagged item’s in-flight memory
  location.

There are no `assume` statements. The harness structurally holds reset low
until each clock has had an edge, and makes reset permanently high thereafter.
Both clocks and all transaction inputs/data remain unconstrained. As with the
rest of this formal abstraction, reset recovery/removal timing is not modeled.

The tagged sequence index is frozen from a free input and spans two pointer
laps; the finite scoreboard counters wrap at `2**(ADDR_WIDTH+1)`.

| Command/configuration | Result | Notes |
|---|---|---|
| `sby -f async_fifo_integrity.sby cover` (ADDR_WIDTH=4, depth 44) | PASS, 52 s | All three covers reached: tagged check (step 10), second-lap tag check (step 42), and both counters beyond the first lap (step 42). |
| `sby -f async_fifo_integrity.sby bmc` (ADDR_WIDTH=4, depth 44) | TIMEOUT, 1800 s | The completed sweep run hit its timeout. A prior preserved attempt had reached step 25 without a result. |
| `sby -f async_fifo_integrity.sby prove` (ADDR_WIDTH=4, depth 44) | TIMEOUT, 1800 s | The completed sweep run hit its timeout; no unbounded proof result. |
| Width-2, depth-20 integrity BMC | PASS, 128 s | Bounded to 20 global steps; not an unbounded proof. |
| Width-2, depth-20 integrity prove | UNKNOWN, 122 s | Base case passed; temporal induction failed on helper and tagged-item assertions. This is an unreachable-state induction failure, not a reachable counterexample. |
| Width-2 cover, depth 20 | FAIL | Tagged check and first-lap cover reached, but second-lap tagged cover was beyond this bound. |
| Width-2 cover, depth 32 | PASS, 11 s | Reached the second-lap tagged cover at step 24. |
| Width-4 integrity cover, depth 44 | PASS, 52 s | Tagged check at step 10; second-lap tag check and both counters beyond the first lap at step 42. |

The hierarchical reference to `dut.u_mem.mem[...]` elaborates successfully.
The additional in-flight assertions are themselves asserted (never assumed),
but the current induction run still cannot establish them from arbitrary
induction states. The Phase 2 safety properties are therefore **not proven
unbounded**.

## Mutation tests

All mutations were applied only to copies under `mutants/`.

| Mutation | Result | Property that caught it |
|---|---|---|
| Remove `~wr_full` from write-pointer increment | FAIL | P2a no-overflow |
| Remove `~rd_empty` from read-pointer increment | FAIL | P2b no-underflow; tagged integrity also fails |
| Write memory at address +1 | FAIL | P2c tagged-data equality |
| Wrong bit in `wr_full_next` Gray comparison | FAIL at step 9 | P2d full-comparison helper assertion |

All four specified mutations were detected. The wrong-full-comparison mutant
was not caught by the initial integrity assertions; adding P2d made the
mutation fail. The unmodified width-2 control passed the 16-step BMC both
before and after adding P2d.

Reproduction commands (run from `phase 2 and 3/`):

```sh
(cd mutants/wr_full_gate && sby -f quick.sby bmc)
(cd mutants/rd_empty_gate && sby -f quick.sby bmc)
(cd mutants/write_addr && sby -f quick.sby bmc)
(cd mutants/full_compare && sby -f flagcheck.sby bmc)
```

## Phase 3 sweep

The command `./sweep.sh` was run with defaults (`ADDRS="2 3 4 5"`,
`DATA_W=8`, `TIMEOUT=1800`, tasks `bmc prove cover`, and both SBY files).
The full 24-run result set is in [`sweep_results.csv`](../sweep_results.csv);
the plotted output is [`runtime_vs_depth.png`](../runtime_vs_depth.png).

The original sweep depth formula is
`2**(ADDR_WIDTH+1) + 12`. At width 2 this bound is insufficient for the
second-lap tagged cover; the standalone width-2 cover passed at depth 32.
Interpret width-2 cover status accordingly. The width-2 sweep also confirms
the multiclock Phase 1 BMC/prove failures repeat at reduced depth, while its
Phase 1 covers pass.

| Entries | SBY file | Task | Result | Seconds |
|---:|---|---|---|---:|
| 4 | `async_fifo_multiclock.sby` | bmc | FAIL | 2 |
| 4 | `async_fifo_multiclock.sby` | prove | FAIL | 2 |
| 4 | `async_fifo_multiclock.sby` | cover | PASS | 3 |
| 4 | `async_fifo_integrity.sby` | bmc | PASS | 128 |
| 4 | `async_fifo_integrity.sby` | prove | UNKNOWN | 122 |
| 4 | `async_fifo_integrity.sby` | cover | FAIL | 2 |
| 8 | `async_fifo_multiclock.sby` | bmc | FAIL | 2 |
| 8 | `async_fifo_multiclock.sby` | prove | FAIL | 2 |
| 8 | `async_fifo_multiclock.sby` | cover | PASS | 2 |
| 8 | `async_fifo_integrity.sby` | bmc | PASS | 1467 |
| 8 | `async_fifo_integrity.sby` | prove | UNKNOWN | 1593 |
| 8 | `async_fifo_integrity.sby` | cover | PASS | 6 |
| 16 | `async_fifo_multiclock.sby` | bmc | FAIL | 3 |
| 16 | `async_fifo_multiclock.sby` | prove | FAIL | 2 |
| 16 | `async_fifo_multiclock.sby` | cover | PASS | 3 |
| 16 | `async_fifo_integrity.sby` | bmc | TIMEOUT | 1800 |
| 16 | `async_fifo_integrity.sby` | prove | TIMEOUT | 1800 |
| 16 | `async_fifo_integrity.sby` | cover | PASS | 47 |
| 32 | `async_fifo_multiclock.sby` | bmc | FAIL | 2 |
| 32 | `async_fifo_multiclock.sby` | prove | FAIL | 3 |
| 32 | `async_fifo_multiclock.sby` | cover | PASS | 2 |
| 32 | `async_fifo_integrity.sby` | bmc | TIMEOUT | 1800 |
| 32 | `async_fifo_integrity.sby` | prove | TIMEOUT | 1800 |
| 32 | `async_fifo_integrity.sby` | cover | PASS | 663 |

The runtime increase is already pronounced from 4 entries to 8 entries: the
bounded integrity run grew from 128 s to 1467 s. At 16 entries, both BMC and
prove hit the 1800 s limit; the 32-entry BMC and prove also timed out. Covers
remain reachable but take 663 s at 32 entries. Thus no depth-32 proof passed.

## Reproduction commands

Run from `phase 2 and 3/`:

```sh
sby -f async_fifo_integrity.sby bmc
sby -f async_fifo_integrity.sby cover
sby -f async_fifo_integrity.sby prove
sby -f async_fifo_multiclock.sby
./sweep.sh
python3 plot_sweep.py
```

The sweep makes per-width copies under `sweep_work/`, so parameter substitutions
do not modify the source RTL or original SBY files. For the width-2 second-lap
cover control, use a copy of the integrity SBY config with `depth 32`.

## What remains unproven

* The width-4 full-depth integrity BMC and prove tasks did not finish within
  the 30-minute budget.
* The induction failure is not a reachable counterexample and does not prove
  the properties false; it means the present invariants are insufficient for
  this engine/model to establish the safety claims.
* Phase 1 multiclock safety assertion at line 131 remains an independent
  checker/model concern and was not changed under the Phase 0/1 freeze.
