# Phase 2/3 Verification Audit

## Metadata

| Item | Value |
|---|---|
| Project | Gray-code CDC asynchronous FIFO |
| Audit date | 2026-10-11 (machine-local date recorded in evidence logs) |
| Tools | Yosys 0.69+20; SBY 0.69; Z3 4.13.3; Python 3.14.4; matplotlib 3.11.2 |
| RTL policy | No RTL edit; Phase 0/1 sources/configuration unchanged |
| Input hashes | Initial snapshot [`evidence/input_hashes.csv`](./evidence/input_hashes.csv); final protected/current inputs [`evidence/final_input_hashes.csv`](./evidence/final_input_hashes.csv); RTL comparison [`evidence/rtl_integrity_check.log`](./evidence/rtl_integrity_check.log) |
| Evidence archive | [`evidence/original/`](./evidence/original/) |

The current audit is intentionally incomplete where a clean run did not
finish. `NOT VERIFIED`, `PARTIAL`, and `TIMEOUT` are not passes. See the
process report for observed/inferred distinctions and the two problem logs.

## Claims ledger

| Claim | Status | Command / check | Evidence |
|---|---|---|---|
| C01 — Audited RTL is unchanged and the protected Phase 1 sources were not edited | VERIFIED | SHA-256 comparisons; `git hash-object`; `git diff --ignore-space-at-eol --exit-code HEAD -- rtl/async_fifo.sv` | [`input_hashes.csv`](./evidence/input_hashes.csv), [`final_input_hashes.csv`](./evidence/final_input_hashes.csv), [`rtl_integrity_check.log`](./evidence/rtl_integrity_check.log) |
| C02 — The default Phase 1 model converts asynchronous resets to a single-step model | VERIFIED | `sby -f async_fifo.sby`; inspect generated `design_prep.ys` | [`final_phase1_default.log`](./evidence/final_phase1_default.log), [`final_clock_model_inspection.txt`](./evidence/final_clock_model_inspection.txt) |
| C03 — Phase 1 properties pass with independent clocks | FAILED | `sby -f async_fifo_multiclock.sby` | [`final_phase1_multiclock.log`](./evidence/final_phase1_multiclock.log); VCD in `async_fifo_multiclock_bmc/engine_0/trace.vcd` |
| C04 — Structural reset and tag-stability self-check assertions are inductively proven at widths 2–5 | VERIFIED | `sby -f async_fifo_integrity_selfcheck.sby prove` on copied widths 2–5 | Width 2 [`selfcheck_final/addr_2_prove/run3.log`](./evidence/selfcheck_final/addr_2_prove/run3.log); widths 3–5 `selfcheck_audit/addr_{3,4,5}/run_prove.log` |
| C05 — Phase 2 width-4 tag, second-lap, and pointer-wrap covers are reached on current F6 source | VERIFIED | `sby -f async_fifo_integrity.sby cover` within the clean F6 sweep | [`sweep_work/addr_4/log_async_fifo_integrity_cover.txt`](../sweep_work/addr_4/log_async_fifo_integrity_cover.txt) |
| C06 — Phase 2 width-4 bounded safety checks pass within the sweep bound | NOT VERIFIED | Final F6 sweep BMC outcome and exact depth recorded in `sweep_results.csv`; a timeout is not a pass | [`sweep_results.csv`](../sweep_results.csv), [`sweep_work/addr_4/log_async_fifo_integrity_bmc.txt`](../sweep_work/addr_4/log_async_fifo_integrity_bmc.txt) |
| C07 — Phase 2 helper assertions establish an unbounded integrity proof | NOT VERIFIED | F6 k=2/k=4 experiments have basecase PASS / induction FAIL / final UNKNOWN; final sweep prove outcome is also logged | [`final_f6/prove_k2.log`](./evidence/final_f6/prove_k2.log), [`final_f6/prove_k4.log`](./evidence/final_f6/prove_k4.log), [`sweep_work/addr_4/log_async_fifo_integrity_prove.txt`](../sweep_work/addr_4/log_async_fifo_integrity_prove.txt) |
| C08 — M1–M5 are detected by Phase 2 bounded checks on final F6 source | PARTIAL | Earlier width-2/data-width-1 mutant copies detected all five before F6; final F6 mutation rerun pending | `mutants/audit_current/M*/phase2_bmc_retry.log` |
| C09 — M1–M5 are detected by Phase 1 bounded checks | PARTIAL | Isolated copies; `sby -f async_fifo.sby bmc` | `mutants/audit_current/M*/phase1_bmc.log`; only M4 fails |
| C10 — Sweep classification and parameter rewrite are correct for the clean final F6 sweep | VERIFIED | `./sweep.sh`; compare all 24 rows to task logs | [`final_f6_sweep.log`](./evidence/final_f6_sweep.log), [`sweep_row_audit.log`](./evidence/sweep_row_audit.log), [`elaborated_widths.txt`](./evidence/elaborated_widths.txt) |
| C11 — The corrected default Phase 3 sweep and plot were completed on final F6 source | VERIFIED | `./sweep.sh`; `python3 plot_sweep.py` | [`final_f6_sweep.log`](./evidence/final_f6_sweep.log), [`fresh_plot.log`](./evidence/fresh_plot.log), [`sweep_results.csv`](../sweep_results.csv), [`runtime_vs_depth.png`](../runtime_vs_depth.png) |

## Critical-read suspects (S1–S9)

| Suspect | Result | Evidence |
|---|---|---|
| S1 — Phase 1 default may be single-clock | **Confirmed.** Generated model contains `async2sync`; multiclock configuration contains `clk2fflogic`. | [`clock_model_inspection.txt`](./evidence/clock_model_inspection.txt) |
| S2 — `tag_seq` may change after capture | **Self-check passed.** Asserted frozen-tag relation is inductively proven at widths 2–5; no assumption is used. | [`selfcheck_final/addr_2_prove/run3.log`](./evidence/selfcheck_final/addr_2_prove/run3.log), [`selfcheck_audit/addr_5/run_prove.log`](./evidence/selfcheck_audit/addr_5/run_prove.log) |
| S3 — Reset may rise more than once or fall | **Structural reset plus asserted invariants proven.** `wr_seen` and `rd_seen` are sticky and combined as `rst_n`; the prior-high checks prove at widths 2–5. This harness does not test external reset reassertion. | Self-check prove logs listed for S2; harness source [`async_fifo_integrity_selfcheck.sv`](../async_fifo_integrity_selfcheck.sv) |
| S4 — BMC/cover depth may be too short for the maximum tag at swept widths | **Partially verified.** The previous script gave only 28/44 steps at widths 3/4, while max-tag witnesses occur at steps 40/72. The final script gives depths 32/44/76/140 at widths 2–5; widths 2–4 witnesses fit. Both width-5 depth-160 attempts timed out at step 102 after 1800 seconds; the second fixed the tag to maximum and reduced DATA_WIDTH to 1. Neither establishes the full sweep's width-5 depth-140 result. | [`classification_real/verification.log`](./evidence/classification_real/verification.log), [`selfcheck_audit/addr_3/run_cover.log`](./evidence/selfcheck_audit/addr_3/run_cover.log), [`selfcheck_audit/addr_4/run_cover.log`](./evidence/selfcheck_audit/addr_4/run_cover.log), [`selfcheck_audit/addr_5/run_cover_status.txt`](./evidence/selfcheck_audit/addr_5/run_cover_status.txt), [`selfcheck_final/addr_5_depth160/run_cover_depth160.log`](./evidence/selfcheck_final/addr_5_depth160/run_cover_depth160.log), [`selfcheck_final/addr_5_depth160/run_cover_depth160_status.txt`](./evidence/selfcheck_final/addr_5_depth160/run_cover_depth160_status.txt), [`selfcheck_max_tag_width5/run/max_tag_width5_retry.log`](./evidence/selfcheck_max_tag_width5/run/max_tag_width5_retry.log), [`selfcheck_max_tag_width5/run/max_tag_width5_retry_status.txt`](./evidence/selfcheck_max_tag_width5/run/max_tag_width5_retry_status.txt) |
| S5 — Immediate assertions may not be evaluated with `multiclock on` | **Assertions were evaluated in multiclock runs.** Standalone self-check induction and final F6 cover/safety outcomes are recorded; F6-only k=2/k=4 induction results are UNKNOWN. | [`selfcheck_audit/addr_4/run_prove.log`](./evidence/selfcheck_audit/addr_4/run_prove.log), [`sweep_work/addr_4/log_async_fifo_integrity_cover.txt`](../sweep_work/addr_4/log_async_fifo_integrity_cover.txt), [`final_f6/prove_k4.log`](./evidence/final_f6/prove_k4.log) |
| S6 — Clocks may not be truly independent | **Independent edge covers reached** for widths 2–4 in both directions: two write-clock edges without a read-clock edge and the reverse. | [`selfcheck_audit/addr_2/run_cover.log`](./evidence/selfcheck_audit/addr_2/run_cover.log), [`selfcheck_audit/addr_4/run_cover.log`](./evidence/selfcheck_audit/addr_4/run_cover.log) |
| S7 — Swept parameters may not change elaboration | **Confirmed for ADDR_WIDTH 2–5.** Pointer widths and memory sizes change as expected in elaborated copies. | [`elaborated_widths.txt`](./evidence/elaborated_widths.txt) |
| S8 — Sweep script may misclassify PASS/FAIL/unreached-cover/TIMEOUT | **Verified.** Actual SBY classifier cases and the full sweep generated 24 CSV task rows with corresponding task logs. | [`classification_real/verification.log`](./evidence/classification_real/verification.log), [`fresh_sweep.log`](./evidence/fresh_sweep.log), [`sweep_row_audit.log`](./evidence/sweep_row_audit.log) |
| S9 — A prove success may rely on assumed helper invariants | **No helper assumptions found.** Phase 2 prove has no terminal success; F7/F8 helper assertions are not proven by the current induction trials. Standalone self-check invariants are asserted and proven, not assumed. | [`assertion_counts.csv`](./evidence/assertion_counts.csv), [`fix8_width4/prove_k2.log`](./evidence/fix8_width4/prove_k2.log), [`fix8_width4/prove_k4.log`](./evidence/fix8_width4/prove_k4.log), self-check prove logs |

### Phase 1 independent-clock failure analysis

The current log fails at step 9 on
`assert (rd_empty == (rd_gray_ptr == wr_gray_sync_prev))`. The saved trace
shows `rd_rst_n` dropping and returning high between sampled history values;
the checker retains a prior synchronized-pointer sample and compares it after
the asynchronous reset has changed the DUT state. Since the Phase 1 reset
inputs are unconstrained, this is a checker/reset-history modeling failure.
No RTL defect is established. Per instruction, Phase 1 files were not changed.

## Mutation matrix

All tests below are bounded BMCs on isolated copies only. ADDR_WIDTH=2 and
DATA_WIDTH=1 were used for the Phase 2 copies to reduce runtime. PASS in a
Phase 1 mutation row means only that Phase 1's selected BMC did not catch that
mutant; it is not evidence the mutant is equivalent.

| Mutant | Phase 1 BMC | Phase 2 BMC | Observed failing property |
|---|---|---|---|
| M1 — remove `~wr_full` from write-pointer increment | PASS | FAIL, step 13 | Tagged in-flight memory assertion and `wr_cnt == dut.u_wr_ptr.wr_bin`; P2a did not appear in the reported failing assertions |
| M2 — remove `~rd_empty` from read-pointer increment | PASS | FAIL, step 5 | No-underflow (`wr_cnt != rd_cnt`), read pointer/scoreboard and tagged checks |
| M3 — write memory at address +1 | PASS | FAIL, step 3 | Tagged in-flight memory assertion |
| M4 — wrong bit comparison in `wr_full_next` | FAIL, step 5 | FAIL, step 7 | Phase 1 full-flag formula; Phase 2 full-comparator helper assertion |
| M5 — cross binary pointers instead of Gray | PASS | FAIL, step 9 | Phase 2 no-underflow (`wr_cnt != rd_cnt`) |

Logs and counterexample traces are retained under
[`mutants/audit_current/`](../mutants/audit_current/). The first Phase 2
mutation launch had an SBY config BOM error; the retry logs cited above are
the actual formal results. These Phase 2 mutant copies predate F6; no
final-revision Phase 2 mutation rerun was completed.

## Sweep results

The clean Phase 3 sweep ran at ADDR_WIDTH 2–5, DATA_WIDTH=8, with 24 tasks
and default 1800-second per-task timeouts. This sweep was run before the
later F6–F8 helper-assertion additions. Its CSV and task logs verify that
revision only; the current source has a fresh cover pass, but a current-source
full sweep and BMC have not been performed. Fresh rows:

| ADDR_WIDTH | Entries | Depth | Phase 1 BMC / prove / cover | Phase 2 BMC / prove / cover |
|---:|---:|---:|---|---|
| 2 | 4 | 32 | FAIL / FAIL / PASS | TIMEOUT / TIMEOUT / PASS |
| 3 | 8 | 44 | FAIL / FAIL / PASS | TIMEOUT / TIMEOUT / PASS |
| 4 | 16 | 76 | FAIL / FAIL / PASS | TIMEOUT / TIMEOUT / PASS |
| 5 | 32 | 140 | FAIL / FAIL / PASS | TIMEOUT / TIMEOUT / PASS |

Archived historical rows, for comparison only:

| ADDR_WIDTH | Entries | Depth | Phase 1 BMC / prove / cover | Phase 2 BMC / prove / cover |
|---:|---:|---:|---|---|
| 2 | 4 | 20 | FAIL / FAIL / PASS | PASS 128s / UNKNOWN 122s / FAIL (unreached cover) |
| 3 | 8 | 28 | FAIL / FAIL / PASS | PASS 1467s / UNKNOWN 1593s / PASS 6s |
| 4 | 16 | 44 | FAIL / FAIL / PASS | TIMEOUT 1800s / TIMEOUT 1800s / PASS 47s |
| 5 | 32 | 76 | FAIL / FAIL / PASS | TIMEOUT 1800s / TIMEOUT 1800s / PASS 663s |

The original depth-20 width-2 Phase 2 cover did not reach the second-lap
cover. The corrected script raises the minimum depth to 32. The fresh plot
[`../runtime_vs_depth.png`](../runtime_vs_depth.png) is based on the current
CSV from the completed pre-F6–F8 run; the separate archived plot
[`evidence/original_runtime_vs_depth.png`](./evidence/original_runtime_vs_depth.png)
was generated from the archived CSV. In that pre-F6–F8 fresh sweep, Phase 2 covers
completed at every width, while Phase 2 BMC/prove timed out at all widths.
The historical rows show Phase 2 BMC rising from 128 seconds at
ADDR_WIDTH=2 to 1467 seconds at ADDR_WIDTH=3, then times out at the 1800-second
cap for widths 4 and 5. The sharp observed runtime increase begins between
widths 2 and 3; this is historical evidence, not a fresh scaling measurement.

## Assertion/cover/assume/initial counts

Counts exclude comments and compare preserved original Phase 1/Phase 2
property files with the corresponding current files. The standalone
self-check is a new file and is shown separately.

| File set | assert | cover | assume | initial |
|---|---:|---:|---:|---:|
| Original Phase 1 property file | 6 | 3 | 0 | 2 |
| Final Phase 1 property file | 6 | 3 | 0 | 2 |
| Original Phase 2 harness | 14 | 3 | 0 | 2 |
| Final Phase 2 harness (F6) | 16 | 3 | 0 | 2 |
| Added standalone self-check | 9 | 6 | 0 | 1 |

No assertion in the original Phase 1 or Phase 2 files was removed, weakened,
or gated away. The active Phase 2 source is the committed F6 revision and
contains two additional reset-history assertions, not assumptions. The later
F7/F8 pointer, occupancy, Gray-code, and synchronizer helper assertions were
tested only as experiments: k-induction failed on them, so they were excluded
from the final harness rather than presented as proven invariants. The
exclusion is documented in [`discarded_f7_f8.diff`](./evidence/discarded_f7_f8.diff)
and the failed experiments remain in the evidence archive. Phase 2 safety
remains unresolved. The standalone self-check also contains two asserted
reset-history invariants, proven by induction. A draft count file reported
11 assertions and 7 covers
for the self-check; a comment-stripped source recount found 9 and 6. The
incorrect draft is preserved as
[`assertion_counts_initial_draft.csv`](./evidence/assertion_counts_initial_draft.csv).
The pre-fix counts are preserved in
[`evidence/assertion_counts_before_fix6.csv`](./evidence/assertion_counts_before_fix6.csv);
the updated machine-readable counts and recount log are in
[`evidence/assertion_counts.csv`](./evidence/assertion_counts.csv) and
[`evidence/assertion_counts_final.log`](./evidence/assertion_counts_final.log),
with a source recount of the final F6 harness in
[`evidence/assertion_counts_current.log`](./evidence/assertion_counts_current.log).

## Assumption register

| Assumption / constraint | Implementation | Justification and effect |
|---|---|---|
| None expressed with formal `assume` | 0 `assume(...)` statements in original property files and added self-check | No artificial restriction on clock ratios, transaction controls, or data was imposed. |
| Shared structural reset in Phase 2 harness | `rst_n = wr_seen & rd_seen`; reset stays high afterward | Harness guarantees one reset-observing edge per domain before checks; does not model reset reassertion or recovery/removal timing. This is an explicit harness restriction, not an SBY assumption. |
| Frozen arbitrary tag | Sampled once from free `tag_seq_in` | Checker choice, not an environmental assumption; establishes one fixed sequence position for the scoreboard. |

## Precisely proven and not proven

* **Proven:** Phase 1 properties pass only in the default converted-clock
  model. The self-check reset-history and frozen-tag invariants are proven by
  k-induction at widths 2–5 (see logs).
* **Proven as reachability:** Phase 2 width-4 cover goals reach on the current
  checker source; the width-2–4 self-check maximum-tag and independent-clock goals reach. At
  width 5, the depth-96 run ended with an unreached maximum-tag cover and both
  depth-160 attempts timed out at step 102. No width-5 max-tag reachability
  claim is made.
* **Bounded mutant detection:** The earlier Phase 2 BMC revision catches
  M1–M5; that mutation run predates F6. The Phase 1 BMC catches M4 only.
* **Not proven:** Independent-clock Phase 1 safety; width-5 standalone
  self-check maximum-tag cover; Phase 2 bounded and unbounded safety
  (prior BMC/prove timed out at every swept width; current F6 k=2/k=4
  induction is UNKNOWN); final-revision Phase 2 mutant checks; Phase 1/Phase 2
  mutant prove or cover tasks. TIMEOUT rows are not passes.

## Changes to files

* `phase_2_and_3/sweep.sh`: corrected shallow-cover classification and
  increased the selected sweep bound after observed width-3/4 cover witnesses.
* `phase_2_and_3/async_fifo_integrity_selfcheck.sv` and `.sby`: added the
  standalone reset/tag/clock self-check and increased only its cover depth.
* `phase_2_and_3/async_fifo_integrity_top.sv`: final active source is committed
  F6, with two asserted reset-history invariants. F7/F8 experimental helper
  assertions were excluded after induction failure and are documented in
  saved diffs. No original property was altered and no `assume` was added.
* `results/`: audit/process reports, machine-readable summary, hashes,
  assertion counts, saved command outputs, VCDs, diffs, and evidence index.
* `mutants/audit_current/`, `sweep_work/`, `sweep_results.csv`, and
  `runtime_vs_depth.png`: isolated mutation copies and sweep-generated data.
  `async_fifo.sv` and Phase 1 sources/configurations were not modified.

## Final reconciliation update

**C03 is verified after a checker-only repair.** The old tracked blob fails
the read-empty checker relation at step 9 after an asynchronous read-reset
pulse leaves sampled history stale. The repair asynchronously resets the
checker history exactly as the DUT resets its state; it adds no `assume` and
does not remove or weaken an assertion. Final BMC reruns at ADDR_WIDTH 2–5
(depth 30) pass in 22, 20, 31 and 18 seconds. See
[`c03_triage.md`](./evidence/c03_triage.md).

The 24 sweep rows came from the completed **pre-F6** harness copied into
`sweep_work/addr_{2,3,4,5}`. `final_input_hashes.csv` identifies the source
snapshot for that run; these rows remain historical evidence, not a claim
about the checker after this C03 repair. The stale statements that a sweep is
underway are superseded: no sweep is currently running. The archived
[`original/sweep_results.csv`](./evidence/original/sweep_results.csv) is the
old shallow-depth sweep; the root `sweep_results.csv` is its later corrected-
depth pre-F6 successor. `report_corrections=2` records the prior depth/status
correction and this source-revision/C03 reconciliation.

Phase-2 feasibility used DATA_WIDTH=1 as a **data-independence experiment**:
it does not prove all data widths. At depth 20, SMT BMC passed with helpers
in 70 s and with helpers compiled out in 67 s, so helpers were not the
dominant cost at that bound. Boolector errored in 1 s; Yices is unavailable.
ABC PDR is prove-only (the attempted BMC configuration errors); at depth 32,
ABC PDR/prove passed in 43 s (baseline) and 116 s (no-helper), while ABC
BMC3 passed in 10 s and 33 s. The Z3 depth-32 baseline was externally stopped
after 55 minutes without a terminal result, so it is not reported as a pass
or timeout. These data are retained under `p2_feasibility/`.

## Reproduction commands

Commands were run in WSL. Logs are named in the claims ledger.

```sh
cd formal && sby -f async_fifo.sby
cd ../phase_2_and_3 && sby -f async_fifo_multiclock.sby
sby -f async_fifo_integrity.sby cover
sby -f async_fifo_integrity.sby bmc
sby -f async_fifo_integrity.sby prove
./sweep.sh
python3 plot_sweep.py
```

The full-sweep commands above remain reproduction instructions, not claims
that those commands completed in this audit.
