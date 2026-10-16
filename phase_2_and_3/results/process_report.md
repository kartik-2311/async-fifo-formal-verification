# Phase 2/3 Independent Verification Process Report

## Scope and present conclusion

This report records an independent audit of the Phase 2 integrity harness and
Phase 3 sweep. `async_fifo.sv`, the Phase 1 property file, and the Phase 1
configuration were not edited. The working tree is not a clean checkout:
the Git status, history, timestamps, saved work directories, sweep CSV, prior
mutants, and the matching Claude project transcript were copied before this
audit reran generated work. See
[`evidence/original/`](./evidence/original/).
The preserved pre-audit `git status` already showed four deletions under
`phase 2 and 3/` and an untracked `phase_2_and_3/` copy; this audit did not
restore or stage those paths.

Observed clean checks in this session: Phase 1's default configuration passes
its BMC, prove, and cover tasks; its independent-clock configuration fails
BMC and prove at `async_fifo_formal.sv:131`, while cover passes. The Phase 2
width-4 cover reaches all three goals. The standalone reset/tag self-check
has passed induction at ADDR_WIDTH 2, 3, 4, and 5; its cover run has passed
at widths 2, 3, and 4. Its width-5 cover at depth 96 ended with an unreached
maximum-tag goal; both the full depth-160 retry and a narrowed fixed-tag,
DATA_WIDTH=1 retry timed out after 1800 seconds at step 102. The earlier
pre-F6 Phase 2 BMC reached step 28 and was stopped at the 30-minute audit cap;
the unbounded prove also timed out at the 1800-second cap after basecase step
28. Neither result proves or falsifies the current active F6 source.

The reports therefore do **not** claim an unbounded Phase 2 integrity proof.
The earlier complete default Phase 3 sweep and plot were run and retained,
but that sweep predates F6 and is not evidence for the active final checker.
The active checker is the committed F6 revision: unproven F7/F8 helper
experiments were excluded, without changing the original assertions. A fresh
full sweep on F6 is currently running. F6-only k=2 and k=4 induction trials
have basecase passes but induction failures; Phase 2 safety remains
unresolved.

## Toolchain and machine

Recorded in [`evidence/tool_versions.log`](./evidence/tool_versions.log):
Yosys 0.69+20, SymbiYosys 0.69, Z3 4.13.3, Python 3.14.4, matplotlib 3.11.2,
WSL2 Linux kernel 6.18.33.2. `pandoc` was not found. The log also preserves
one failed shell-quoting attempt while querying matplotlib; a direct WSL
invocation then returned 3.11.2.

## What was checked

### Phase 2 harness

The harness in `async_fifo_integrity_top.sv` uses independently ticking write
and read clocks, free transaction inputs and data, a sequence-number
scoreboard, and a shared reset generated structurally from the first observed
edge of each clock. It has no `assume` statements. Its assertions cover
accepted-write overflow, accepted-read underflow, accepted pointer/scoreboard
consistency, Gray-pointer encoding, full-flag comparison, and the tagged
item's in-flight memory location and read data. A free tag input is sampled
once and held by the checker.

The structural reset is a harness restriction, not a modeled arbitrary
external reset: each clock must tick before reset releases, and it never
reasserts. Recovery/removal timing is not modeled. No fairness or clock-ratio
assumption is imposed. The existing hierarchical references into the FIFO
pointer and memory instances elaborate successfully under the configured
slang/Yosys flow; Phase 2 cover and mutant BMC runs proceeded without requiring
bind or harness restructuring (see [`phase2_cover.log`](./evidence/phase2_cover.log)
and the Phase 2 mutant retry logs).

### Phase 3 sweep

`sweep.sh` copies sources to per-width work folders, rewrites ADDR_WIDTH and
DATA_WIDTH defaults in those copies, chooses a BMC/cover depth of
`max(2**(ADDR_WIDTH+2)+12, 32)`, and records return status and elapsed
seconds. The script was fixed to distinguish SBY's unreached-cover diagnostic
from an assertion failure. After maximum-tag cover witnesses reached steps
40 and 72 at widths 3 and 4, the depth formula was increased; the final script
computes depths 32, 44, 76, and 140 for widths 2–5. Real SBY cases were run through the script for
PASS, assertion FAIL, unreached cover, and a one-second externally timed-out
proof; a saved checker confirms each CSV status against its raw task log.
The corrected default complete sweep was rerun for ADDR_WIDTH 2–5, and its
CSV, per-task logs, row audit, and plot are retained for the pre-F6 harness.
A second clean full sweep is now running against F6; its exact output and
result table will supersede the earlier sweep for final-source reporting.

The independent self-check copies elaborated with pointer widths 3, 4, 5,
and 6 and memory sizes 4, 8, 16, and 32 for ADDR_WIDTH 2–5 respectively.
That is direct parameter-elaboration evidence, but it is not a completed
`sweep.sh` run. See [`evidence/elaborated_widths.txt`](./evidence/elaborated_widths.txt).

## Chronology

### Preserved original work (observed from files/transcript)

1. The original sweep CSV records width-2 integrity cover as FAIL at depth 20,
   and the preserved SBY log explains it with the exact diagnostic
   `Unreached cover statement at async_fifo_integrity_top: async_fifo_integrity_top.sv:214.11-214.54`.
2. The original width-4 Phase 2 prove log records an induction failure at
   `async_fifo_integrity_top.sv:76.7-76.30`; it does not establish a reachable
   counterexample or an unbounded proof.
3. The original width-3 Phase 2 prove row is UNKNOWN after 1593 seconds.
   Width-4 and width-5 Phase 2 BMC/prove rows are TIMEOUT at 1800 seconds.
   These are historical CSV entries, not reruns here.
4. The preserved old M1–M4 `run_bmc.log` files terminate with
   `SBY ---- Keyboard interrupt or external termination signal ----`.
   Those files do not support a completed mutation-pass claim.
5. The prior source report and Claude transcript contain additional narrative
   claims; where no complete run log exists, this report does not promote
   those claims to verified results.

### This independent audit (observed)

1. Before reruns, saved the original work directories, sweep data, mutants,
   logs, Git history/status, timestamps, and matching Claude transcript.
2. Compared RTL hashes and Git object hashes. `rtl/async_fifo.sv`,
   `formal/async_fifo.sv`, and `phase_2_and_3/async_fifo.sv` have identical
   SHA-256 values; the working RTL Git object matches `HEAD`. The
   whitespace-insensitive diff exits 0. No RTL edit was made.
3. Ran the default Phase 1 configuration: BMC, prove, and cover all PASS.
   The generated preparation script contains `async2sync`.
4. Ran all Phase 1 multiclock tasks: BMC and prove FAIL at step 9 on
   `async_fifo_formal.sv:131`; cover PASS. The saved VCD shows a reset
   interruption in the read-domain history. This is classified as a checker
   reset/history modeling failure, not a confirmed RTL defect.
5. Ran Phase 2 width-4 cover: PASS; the tag check, second-lap tag check, and
   both-counters-past-first-lap cover are reached at steps 10 and 42.
6. Ran Phase 2 width-4 BMC at depth 44. It reached step 28 and was stopped by
   the auditor at the 1800-second cap. The saved status note records TIMEOUT;
   the raw solver log has no terminal SBY status.
7. Added a standalone self-check file without changing the Phase 2 harness.
   Its first prove attempt failed induction on reset-history assertions.
   Adding asserted combinational reset-history invariants made induction pass
   at widths 2–5. No invariant is assumed. Cover runs pass at widths 2–4;
   width 5 did not reach the maximum-tag cover at depth 96. The full
   depth-160 retry was terminated by the 1800-second cap at step 102; the
   saved log has no terminal cover status. A specialized fixed-tag,
   DATA_WIDTH=1 retry also timed out at step 102. Neither log has a terminal
   cover status.
8. Ran Phase 1 BMC and Phase 2 BMC for each isolated mutation copy M1–M5
   (ADDR_WIDTH=2, DATA_WIDTH=1; Phase 2 depth 32). Phase 1 BMC detects only
   M4. Phase 2 BMC detects all five by asserted properties. A first Phase 2
   mutation attempt failed before elaboration because PowerShell wrote a BOM
   into copied `.sby` files; rewriting those text-only configs without a BOM
   fixed setup, and the retry completed. This tests BMC, not prove/cover, for
   the mutants. The Phase 2 mutant copies predate F6 and were not rerun
   against the current assertion revision.
9. Tested `sweep.sh` classification first with mock SBY results, then with
   actual SBY tasks for PASS, assertion FAIL, UNREACHED_COVER, and TIMEOUT.
   The saved verifier checked the CSV row against each corresponding raw SBY
   log. Also ran a passing fixture at widths 2–5 and checked depths
   32/44/76/140.
10. Raised the sweep depth formula after max-tag cover traces at widths 3 and
    4 reached steps 40 and 72, while the prior formula produced depths 28 and
    44. The new formula is `2**(ADDR_WIDTH+2)+12`, with a minimum of 32;
    width-5 adequacy remains unverified after the depth-160 timeout. Saved
    [`fix_4.diff`](./evidence/fix_4.diff) and committed as `95e5bb9`.
11. Ran the full default `./sweep.sh` for ADDR_WIDTH 2–5, DATA_WIDTH=8,
     and the default 1800-second task timeout. All 24 task rows completed:
     Phase 1 BMC/prove failed and covers passed at each width; Phase 2 covers
     passed and BMC/prove timed out at each width. The per-width CSV rows and
     raw SBY logs were retained.
12. Ran `python3 plot_sweep.py` against the fresh `sweep_results.csv`. The
     resulting current plot and console output are preserved.
13. Attempted a specialized width-5 max-tag cover. The first shell invocation
    failed quoting; the next invocation exposed the wrapper's reserved-word
    instance label, which was renamed in the isolated wrapper only. The
    corrected wrapper elaborates, and the fixed-tag, DATA_WIDTH=1 cover is
    still timed out at step 102 after its own 1800-second cap. Saved the
    one-line change as
    [`fix_5.diff`](./evidence/fix_5.diff) and committed it as `8fa859f`.
14. The fresh width-4 Phase 2 prove sweep produced an induction trace failing
    the reset-history assertion at line 76, while its basecase had not finished.
    The VCD state has `wr_seen=1, wr_reset_done=0`, which cannot follow from
    the initialized harness state. Added two combinational **asserted**
    reset-history invariants (no assumptions) as [`fix_6.diff`](./evidence/fix_6.diff);
    the fresh sweep therefore predates fix_6.
15. Tried F7 pointer/counter, occupancy, and Gray-code assertions and F8
    synchronizer-stage recurrence assertions as induction helpers. Depth-2
    and depth-4 induction failed on the new helper assertions. A first F8
    trial also failed elaboration because ghost-state identifiers were used
    before declaration; moving the declarations fixed elaboration but not the
    induction failures. Because those helper assertions were not proven, I
    removed only those experimental additions and restored the committed F6
    harness. The original Phase 2 assertions were not changed. Source
    differences and failed traces/logs remain in
    [`fix_7.diff`](./evidence/fix_7.diff),
    [`fix_8.diff`](./evidence/fix_8.diff), and
    [`discarded_f7_f8.diff`](./evidence/discarded_f7_f8.diff).
16. On the restored F6 source, depth-2 and depth-4 prove experiments had
    basecase PASS but induction FAIL and final UNKNOWN. At k=2, induction
    failures were at lines 153, 201, and 202 (tag/counter relation and read
    pointer/Gray checks); at k=4, failures were at lines 175, 176, 178, 214,
    and 215 (write pointer/counter, Gray/occupancy, and no-overflow checks).
    These are induction traces, not reachable counterexamples. Logs are in
    [`final_f6/prove_k2.log`](./evidence/final_f6/prove_k2.log) and
    [`final_f6/prove_k4.log`](./evidence/final_f6/prove_k4.log).
17. Re-ran the default and multiclock Phase 1 configurations after restoring
    F6. Default BMC/prove/cover PASS; independent-clock BMC/prove FAIL and
    cover PASS. The generated scripts confirm `async2sync` for default and
    `clk2fflogic` for multiclock. Phase 1 RTL/property/config files remain
    unchanged. Evidence: [`final_phase1_default.log`](./evidence/final_phase1_default.log),
    [`final_phase1_multiclock.log`](./evidence/final_phase1_multiclock.log),
    [`final_clock_model_inspection.txt`](./evidence/final_clock_model_inspection.txt).

## Problems log — original work

| Step | Exact observed symptom | Root cause / class | Fix and files touched | Check and evidence | Source |
|---|---|---|---|---|---|
| Original width-2 cover | `Unreached cover statement at async_fifo_integrity_top: async_fifo_integrity_top.sv:214.11-214.54` at depth 20 | The cover bound was too short; the script also treated the SBY cover-reachability result as a generic failure, not an assertion counterexample | Set minimum sweep depth to 32 and classify the diagnostic as `UNREACHED_COVER`; `sweep.sh` | Real-SBY classifier regression has all four statuses; corrected full sweeps and the original depth-20 log are preserved. | Archived SBY log, CSV, and [`fix_1.diff`](./evidence/fix_1.diff) |
| Original Phase 2 prove | `Assert failed in async_fifo_integrity_top: async_fifo_integrity_top.sv:76.7-76.30 (_witness_.check_3)` in induction | Induction cannot establish the helper assertion from arbitrary induction states; unreachable-state explanation is an inference, not established by a reachability proof | No fix accepted; helper assertions remain assertions, never assumptions | Original induction log; current proof attempt timed out in the basecase and does not revise this historical failure | Archived SBY log and current SBY log |
| Original Phase 2 scaling | CSV records width-3 prove UNKNOWN (1593s), width-4/5 BMC and prove TIMEOUT (1800s) | Solver/runtime scaling is inferred from increasing width and runtime; no new cause established | No change | Historical CSV and corrected full-sweep logs | Archived CSV and fresh sweep |
| Original mutation evidence | Each preserved top-level M1–M4 `run_bmc.log` ends with `SBY ---- Keyboard interrupt or external termination signal ----` | Runs were interrupted; not completed mutation evidence | Re-ran bounded checks on isolated current copies M1–M5 | Current per-mutant BMC logs under `mutants/audit_current/` | Archived logs and current rerun |

## Problems log — this audit

| Step | Exact error or symptom | Root cause / class | Fix and files touched | How checked / evidence | Source |
|---|---|---|---|---|---|
| Initial Phase 1 command | `FileNotFoundError: [Errno 2] No such file or directory: 'async_fifo.sby'` | Ran from `phase_2_and_3`; Phase 1 config is under `formal/`. Environment/setup error. | Reran from `formal/`; no source changed | [`setup_wrong_phase1_directory.log`](./evidence/setup_wrong_phase1_directory.log); successful rerun in [`phase1_default.log`](./evidence/phase1_default.log) | Current command logs |
| Phase 1 multiclock | `failed assertion async_fifo._witness_.check_112 at async_fifo_formal.sv:131.11-131.67 step 9` | Unconstrained reset can pulse asynchronously between sampled read-clock edges, leaving `wr_gray_sync_prev`/read history stale; checker/reset-modeling failure | No Phase 1 edit, per instruction | [`phase1_multiclock.log`](./evidence/phase1_multiclock.log) and generated VCD under `async_fifo_multiclock_bmc/engine_0/trace.vcd` | Current SBY log and trace |
| First standalone reset prove | Induction reports assertions at self-check lines 81, 86 (original run) | Reset-history relation not inductive without a state invariant | Added two combinational **asserted** reset-history invariants in the new self-check; no `assume` added | Earlier failing run preserved under `selfcheck_final/addr_2_prove`; passing `run3.log`, plus widths 3–5 `run_prove.log` | Current SBY logs and source diff |
| First Phase 2 mutation launch | `ERROR: Task name 'bmc' didn't match any lines in [tasks].` | BOM introduced into copied SBY config by PowerShell UTF-8 encoding. Tool/setup error. | Rewrote copied config as ASCII without BOM; source RTL unchanged | Failed `phase2_bmc.log`; successful `phase2_bmc_retry.log` for each M1–M5 | Current SBY logs |
| Phase 2 default BMC | Auditor stopped the width-4, depth-44 run at 1800 seconds; last solver report was step 28 | Runtime exceeded the audit cap; not a property failure | No fix | [`phase2_bmc.log`](./evidence/phase2_bmc.log), [`phase2_bmc_status.txt`](./evidence/phase2_bmc_status.txt) | Current SBY log and status note |
| Phase 2 prove | Timeout wrapper returned 124 at 1800 seconds; last progress was waiting after basecase assertions at step 28 | Runtime cap reached before a terminal proof or counterexample; unbounded property status unresolved | No fix to that recorded run | [`phase2_prove.log`](./evidence/phase2_prove.log), [`phase2_prove_status.txt`](./evidence/phase2_prove_status.txt); fresh width-specific timeout rows in `sweep_results.csv` | Current SBY logs and wrapper status |
| Width-4 induction counterexample | `Assert failed in async_fifo_integrity_top: async_fifo_integrity_top.sv:76.7-76.30 (_witness_.check_3)`; VCD state at time 5 shows `wr_seen=1`, `wr_reset_done=0`, and `rst_n=0` | Unreachable induction state violates the reset-history assertion; this is not a reachable counterexample. The overall width-4 prove task timed out before the basecase completed. | Added two combinational asserted invariants, `!wr_seen || wr_reset_done` and `!rd_seen || rd_reset_done`, to `async_fifo_integrity_top.sv`; no assumption added | Raw trace `sweep_work/addr_4/async_fifo_integrity_prove/engine_0/trace_induct.vcd`; analysis [`induction_reset_trace_analysis.log`](./evidence/induction_reset_trace_analysis.log); final proof of added invariants pending | Current induction log and VCD |
| Width-5 self-check maximum-tag cover | Depth-96 run failed with `Unreached cover statement at async_fifo_integrity_selfcheck: async_fifo_integrity_selfcheck.sv:137.11-137.24 (_witness_.check_159)`; both depth-160 attempts were stopped at 1800 seconds after reaching step 102 | The bound increase alone did not resolve the solver scaling; insufficient depth remains an unconfirmed explanation for the depth-96 unreached cover | Raised only the self-check cover depth from 96 to 160 in `async_fifo_integrity_selfcheck.sby`; prove depth remains 96 | Original failure [`run_cover.log`](./evidence/selfcheck_audit/addr_5/run_cover.log), full [`run_cover_depth160.log`](./evidence/selfcheck_final/addr_5_depth160/run_cover_depth160.log) and targeted [`max_tag_width5_retry.log`](./evidence/selfcheck_max_tag_width5/run/max_tag_width5_retry.log); status notes accompany both | Current SBY logs and depth-setting diff |
| First specialized width-5 invocation | `/bin/bash: -c: line 1: unexpected EOF while looking for matching '"'` | PowerShell-to-WSL argument quoting prevented Bash from parsing the command; command-launch error, no SBY run occurred | Corrected the shell invocation; no source file changed | Exact stderr captured in [`launch_error.log`](./evidence/selfcheck_max_tag_width5/run/launch_error.log); subsequent invocation started SBY | Current command output |
| Specialized width-5 wrapper elaboration | `max_tag_width5.sv:13:23: error: expected identifier` followed by related connection syntax errors; SBY reported `Build failed: 15 errors, 0 warnings` | The experiment wrapper used reserved SystemVerilog keyword `checker` as an instance label; test-wrapper defect, not RTL or property failure | Renamed only the instance label to `u_checker` in `selfcheck_max_tag_width5/run/max_tag_width5.sv` | Failure diagnostics in [`max_tag_width5.log`](./evidence/selfcheck_max_tag_width5/run/max_tag_width5.log) and `max_tag_width5_cover/model/design.log`; corrected design elaboration succeeds; [`fix_5.diff`](./evidence/fix_5.diff) is committed as `8fa859f`. The cover retry result is recorded separately. | Current SBY model log and wrapper diff |
| Sweep maximum-tag depth | Width-3 and width-4 max-tag covers reached at steps 40 and 72; the former script depths were 28 and 44 | The old depth formula was too short for the largest-tag cover at widths 3 and 4; script/depth bug | Changed exponent from `ADDR_WIDTH+1` to `ADDR_WIDTH+2` in `sweep.sh` | Actual cover witnesses, final-script real classifier tests, and a width-2–5 arithmetic/CSV check; width-5 max-tag outcome remains unverified after two TIMEOUTs | Current cover logs, `classification_real/verification.log`, and [`fix_4.diff`](./evidence/fix_4.diff) |
| Draft assertion counts | Draft CSV listed 11 assertions and 7 covers for the standalone self-check; comment-stripped source recount gives 9 and 6 | The stored draft count disagreed with source; why those draft values were entered is not evidenced | Corrected `assertion_counts.csv`; retained the earlier CSV as `assertion_counts_initial_draft.csv` | Recount command recorded in [`assertion_counts_recount.log`](./evidence/assertion_counts_recount.log); corrected CSV and preserved draft | Current source/data audit |
| Fresh sweep Phase 2 BMC/prove | The full sweep recorded TIMEOUT for BMC and prove at every width 2–5; BMC durations are 1800–1924s and prove durations 1800s | SBY/Z3 did not finish these bounded/unbounded obligations within the 1800-second task timeout; timeout remains unresolved rather than a pass/failure | No fix | [`fresh_sweep.log`](./evidence/fresh_sweep.log), [`sweep_results.csv`](../sweep_results.csv), per-task raw logs under `sweep_work/addr_{2,3,4,5}/` | Current SBY logs and CSV |
| Sweep vs harness revision | Earlier full sweep predates F6; F7/F8 were experimental and removed after induction failures | Earlier sweep rows do not establish current-source results; failed helpers are not in active source | Restored committed F6 source, then started a fresh complete sweep (result is being recorded separately) | [`fresh_sweep.log`](./evidence/fresh_sweep.log), [`final_f6_sweep.log`](./evidence/final_f6_sweep.log), [`discarded_f7_f8.diff`](./evidence/discarded_f7_f8.diff) | Current SBY logs and diffs |
| F8 first elaboration | `identifier 'wr_gray_sampled_for_rd' used before its declaration` (same diagnostic for three other ghost registers); `Build failed: 4 errors, 0 warnings` | The experimental ghost-state declarations appeared after their `initial` use; slang requires declaration before use | Moved declarations before `initial` in the F8 experiment; later excluded the unproven F7/F8 helpers from the active checker | Corrected F8 experiment elaborates; first diagnostic was transcribed because the run directory was overwritten. [`fix8_initial_elaboration_failure.txt`](./evidence/fix8_initial_elaboration_failure.txt), [`fix_8.diff`](./evidence/fix_8.diff), [`discarded_f7_f8.diff`](./evidence/discarded_f7_f8.diff) | Current tool output transcription and rerun log |
| Phase 2 F7 k=2 induction experiment | Basecase PASS; induction failed on read-counter/pointer, occupancy, and Gray assertions; final `UNKNOWN` | Added helper assertions were not k-inductive; trace is induction-only, not a reachable counterexample | Excluded unproven helpers from active harness; original assertions remain unchanged | [`fix7_width4/prove_k2.log`](./evidence/fix7_width4/prove_k2.log), VCD trace in same run directory, [`discarded_f7_f8.diff`](./evidence/discarded_f7_f8.diff) | Current SBY log and trace |
| Phase 2 F8 k=4 induction experiment | Basecase PASS; induction failed at lines 175/176 on synchronizer history; final `UNKNOWN` | Added synchronizer recurrence helpers were not k-inductive; trace is induction-only, not a reachable counterexample | Excluded unproven helpers from active harness; original assertions remain unchanged | [`fix8_width4/prove_k4.log`](./evidence/fix8_width4/prove_k4.log), VCD trace in same run directory, [`discarded_f7_f8.diff`](./evidence/discarded_f7_f8.diff) | Current SBY log and trace |
| Final F6 k=2 induction experiment | Basecase PASS; induction failed at lines 153, 201, 202; final `UNKNOWN` | Tag/counter, read-pointer, and Gray assertions are not established by k=2; not a reachable counterexample | No property modified; tested deeper induction | [`final_f6/prove_k2.log`](./evidence/final_f6/prove_k2.log) and `trace_induct.vcd` | Current SBY log and trace |
| Final F6 k=4 induction experiment | Basecase PASS; induction failed at lines 175, 176, 178, 214, 215; final `UNKNOWN` | Pointer/counter, Gray/occupancy, and no-overflow assertions are not established by k=4; not a reachable counterexample | No property modified; recorded as unresolved | [`final_f6/prove_k4.log`](./evidence/final_f6/prove_k4.log) and `trace_induct.vcd` | Current SBY log and trace |
| Mutant-copy config rewrite command | `/bin/bash: -c: line 1: syntax error near unexpected token \`('\`` | Shell quoting split the `sed` expression; no formal run occurred | Rewrote copied SBY/SV files with PowerShell text operations; no source RTL edited | [`report_command_errors.txt`](./evidence/report_command_errors.txt); copied configs inspected under `mutants/final_f6/M1/` | Current command output transcript |
| Evidence-index generation command | `sed: -e expression #1, char 2: unterminated \`s' command`; `xargs: sha256sum: terminated by signal 13` | Incorrect sed quoting broke the index pipeline before a usable index was created | Regenerated index with PowerShell SHA-256 and verified each entry | [`report_command_errors.txt`](./evidence/report_command_errors.txt); final `INDEX.txt` verification | Current command output transcript |
| Generated-clock grep command | `/bin/bash: line 1: clk2fflogic /mnt/c/Users/karti/Projects/async-fifo-formal-verification/formal/async_fifo_*/model/*.ys /mnt/c/Users/karti/Projects/async-fifo-formal-verification/phase_2_and_3/async_fifo_multiclock_*/model/*.ys: No such file or directory` | Quoting/argument parsing misconstructed the grep invocation; it did not inspect the models | Queried model files with PowerShell `Get-ChildItem`/`Select-String` and saved the results | [`report_command_errors.txt`](./evidence/report_command_errors.txt), [`final_clock_model_inspection.txt`](./evidence/final_clock_model_inspection.txt) | Current command output transcript |

### Unconfirmed

* A prior conversation summary says an earlier self-check setup omitted a
  required source file and that an initial mock-SBY script had a CRLF shebang.
  The exact first-error logs were not found in the preserved current evidence;
  those details are not treated as established facts here.
* The preserved pre-audit Git status lists four tracked deletions under
  `phase 2 and 3/` alongside an untracked `phase_2_and_3/` directory. The
  status is observed, but the intent and origin of that directory change are
  not established by the available diff/log evidence; this audit left it alone.
There are two unconfirmed historical details, as listed above. The width-5
maximum-tag cover outcome is not unconfirmed: its depth-96 goal was unreached
and both depth-160 attempts timed out, as evidenced in the referenced logs.

## Final reconciliation update

C03 was reproduced from the old tracked formal blob and classified as checker
reset-history modeling, not an RTL defect. The final checker resets its
history state asynchronously and BMC passes at ADDR_WIDTH 2–5; the trace,
hash comparison, source line, and per-width times are in
[`c03_triage.md`](./evidence/c03_triage.md). No assertion was weakened or
deleted and no assumption was added.

The 24 sweep rows are a completed pre-F6 harness sweep, matched to
`sweep_work/addr_{2,3,4,5}` copies by `final_input_hashes.csv`. The archived
`original/sweep_results.csv` is the older shallow-depth sweep; the current
root CSV is the later corrected-depth pre-F6 sweep. No sweep is underway.
`report_corrections` is now 2: the original depth/status correction and this
source-revision/C03 correction.

Phase-2 DATA_WIDTH=1 results are a data-independence experiment, not a proof
for arbitrary data widths. Depth-20 Z3 BMC: baseline PASS 70 s, no-helper
PASS 67 s. Boolector ERROR 1 s; Yices unavailable; ABC PDR is invalid in BMC
mode. At depth 32, ABC PDR/prove passed in 43 s baseline and 116 s no-helper;
ABC BMC3 passed in 10 s and 33 s. A Z3 depth-32 baseline run was externally
stopped after 55 minutes without a terminal status.

## Final state, limitations, and open questions

* The original Phase 1 checker fails under the genuine independent-clock model
  because its reset history is not robust to arbitrary asynchronous reset
  pulses. Phase 1 files are intentionally unchanged.
* The Phase 2 width-4 cover result from the F6–F8 experiment does not count as
  a current-source result; the F6 full sweep is running. Cover reachability is
  not a safety proof.
* The standalone self-check proves reset-history and frozen-tag invariants at
  widths 2–5. Its width-5 max-tag cover was unreached at depth 96; both
  depth-160 cover attempts timed out at step 102.
* The pre-F6 Phase 2 BMC and unbounded prove timed out at the 30-minute cap.
  Current-source k=2/k=4 induction attempts returned UNKNOWN after induction
  failures; no full Phase 2 safety claim is established.
* Mutation results are bounded only. No mutant prove or cover task was run.
* The earlier complete default sweep, CSV, and plot were completed for the
  pre-F6 harness. A complete F6 source sweep is currently running. The
  script's PASS/FAIL/UNREACHED_COVER/TIMEOUT classification was exercised
  with actual SBY runs in isolated copies, and all 24 earlier sweep rows
  matched their task logs.
* No confirmed RTL bug was produced by the completed runs. The timed-out
  Phase 2 tasks leave the RTL safety result unresolved; this is not a conclusion
  that the RTL is correct.
* The two problem logs contain 4 original-work rows and 22 current-audit rows;
  two items remain explicitly unconfirmed.
* Fix commits recorded in this repository: `35044d7` (sweep classification
  and minimum depth), `0efe713` (standalone reset/tag self-check), `a05d73d`
  (width-5 cover bound), `95e5bb9` (maximum-tag sweep depth), and `8fa859f`
  (isolated retry wrapper), `570a6e2` (Phase 2 reset-history assertions).
  F7/F8 are uncommitted proof experiments, not established fixes. These
  commits are local; nothing was pushed.

## Reproduction commands

Run under WSL from the indicated directories; save stdout/stderr as shown:

```sh
cd formal
sby -f async_fifo.sby
cd ../phase_2_and_3
sby -f async_fifo_multiclock.sby
sby -f async_fifo_integrity.sby cover
sby -f async_fifo_integrity.sby bmc
sby -f async_fifo_integrity.sby prove
sby -f async_fifo_integrity_selfcheck.sby prove
./sweep.sh
python3 plot_sweep.py results/evidence/original/sweep_results.csv results/evidence/original_runtime_vs_depth.png

# Width-5 self-check maximum-tag retry (the 1800-second cap is part of the run)
cd results/evidence/selfcheck_final/addr_5_depth160
timeout 1800 sby -f async_fifo_integrity_selfcheck.sby cover

# Real-SBY sweep status regression cases, from each case folder
cd ../../classification_real/pass
ADDRS=2 TASKS=bmc SBY_FILES=pass.sby SV_FILES=pass.sv TIMEOUT=30 ../../../../sweep.sh
```

The actual commands and outputs run in this audit are retained under
[`evidence/`](./evidence/). Mutation copies use their local `async_fifo.sby`
and `async_fifo_integrity.sby` files and are documented per-run in
`mutants/audit_current/M*/`.
The saved full default sweep ran before the F6–F8 Phase 2 assertion additions;
rerun `./sweep.sh` to measure the current harness revision. Each classifier
case's environment and exact CSV/raw-log pairing are documented in
[`evidence/classification_real/verification.log`](./evidence/classification_real/verification.log).
