# Verification scope and recorded evidence

Evidence cutoff: **30 October 2026**. These are recorded outcomes from the earlier native-Linux/WSL experiments, not a claim that every solver job is rerun whenever documentation changes. The current source release preserves the RTL/checker inputs; runtime outputs are intentionally not versioned. Reproduce individual cases or the bounded matrix using the commands in the root README.

## Engines and model boundaries

- Yosys/slang elaborates immediate SystemVerilog assertions and covers. Recorded versions: Yosys 0.69+20, SBY v0.69, Z3 4.13.3 and ABC 1.01. A zero `assume` count in these sources does not remove structural reset/initialization restrictions.
- ABC `bmc3` performs the main bounded checks; SMTBMC/Z3 supplies recorded induction and cover jobs; ABC PDR supplies the strongest independent-clock safety proofs. `aigsmt z3` converts AIG witnesses and is not a Z3 PDR proof.
- The Phase 1 checker has six history/reset-qualified assertions. Free independent resets are not a promise that queued data survives an independently reset pointer domain.
- Integrity/CDC and late-observer harnesses use one shared startup reset, released after both clocks have ticked and never reasserted.
- The original sixteen-assertion integrity checker chooses one startup tag among two memory laps. A time-unbounded proof of that checker retains its finite item-selection scope.
- The additive observer chooses any accepted write at any time. It retains all sixteen original assertions and adds pending-position, no-overwrite, memory-retention and selected-read checks: twenty targets total. Its W2 theorem applies at arbitrary selection time, but it does not assert eventual delivery or generalize automatically to all widths.
- Covers are existential reachability; PDR/induction PASS is an unbounded safety result for the specified model. Timeout, unknown, unreached cover and infrastructure error are distinct outcomes. The release driver now classifies optional cover scope by task; an inherited optional-unbounded label was a metadata defect, corrected with a regression test.

Here W2 means address width A=2, not two data bits. All FIFO rows below use B=8. Solver steps in a lowered multiclock model are not automatically write cycles, read cycles or nanoseconds.

## Representative convergence results

| Checker/model | Recorded outcome | Launcher wall time |
|---|---|---|
| Phase 1 single-clock Z3 induction W2/W3 | PASS/PASS | 3.845 / 4.540 s |
| Phase 1 single-clock Z3 induction W4/W5 | PASS/PASS | 7.353 / 8.251 s |
| Phase 1 independent PDR W2/W3 | PASS/PASS | 1.344 / 2.547 s |
| Phase 1 independent PDR W4/W5 | PASS/PASS | 7.352 / 18.877 s |
| Original integrity independent PDR W2 | PASS | 66.262 s |
| Original integrity W3, 120-second attempt | TIMEOUT | 120.159 s |
| Original integrity W3, 600-second attempt | PASS | 507.164 s |
| Original integrity W4/W5, 240 seconds each | TIMEOUT/TIMEOUT | 240.257 / 240.210 s |
| Arbitrary-time W2 PDR / identical-input replay | PASS/PASS | 197.752 / 176.579 s |
| Arbitrary-time W3, 300-second attempt | TIMEOUT | 300.254 s |
| Reset-release reference, five assertions | PDR PASS | 0.754 s |

Single-clock induction configured depth 30 and reported success after engine step 27; no minimal-k claim was established. PDR has no reported induction-k result. Times include orchestration/model generation and are not controlled solver CPU benchmarks. A later successful larger-budget run does not relabel the earlier timeout.

The bounded core covers Phase 1 W2-W5 to depth 30, integrity W2 to depth 28 in both clock models, integrity W3 to depth 44 with independent clocks, and the declared mutation/CDC matrices. The historical eight-bit W4 integrity BMC at depth 76 remains TIMEOUT at its 1,800-second budget. Arbitrary-time W4/W5 proofs are NOT RUN after scaling stopped at W3.

## Detection matrix

W2 BMC: Phase 1 independent-clock depth 30; integrity/CDC independent-clock depth 28. Single-clock integrity/CDC outcomes agree for these selected mutations. Mutant PASS means the suite does not detect that mutation.

| Design | Phase 1 | Integrity | Source CDC encoding |
|---|---|---|---|
| Unmodified control | PASS | PASS | PASS |
| M1 remove full guard | PASS | FAIL | PASS |
| M2 remove empty guard | PASS | FAIL | PASS |
| M3 shift memory write address | PASS | FAIL | PASS |
| M4 alter full comparison | FAIL | FAIL | PASS |
| M5b cross binary pointers | PASS | PASS | FAIL |

The invalid stored M5 experiment is excluded. M5b is the valid replacement; M5b_rd2wr is a directional diagnostic, not another independent bug class. Ideal zero-delay integrity checks can miss an encoding violation, which is why the dedicated CDC suite remains necessary. No claim of complete coverage of all possible CDC defects is made.

## Counterexamples and nonvacuity

The original RTL was preserved while checker history/reset qualification was corrected. Branch covers reach the first-active write/read branches at step 3 and normal-history branches at step 5. Initialized full-occupancy covers explicitly require both reset completions and independently counted occupancy equal to capacity; they reach at steps 9 and 17 for W2 and W3.

A shallow historical W5 full-flag witness did not represent filling an initialized 32-entry FIFO: the write pointer stayed zero while an initially arbitrary read pointer/reset history affected synchronized status. The flag cover remains distinct from an initialized occupancy witness. The late observer's concrete equal-clock witness reaches consumption after an extended counter wrap at step 23. A deliberately corrupted capture fails its new memory assertion at step 3. These diagnostic failures and covers are not counted as design safety proofs.

## Reproducibility and file selection

The earlier sealed release reproduced 104 selected outcomes from a separate committed source-only clone: 83 PASS, 20 expected mutation/canary FAIL and one TIMEOUT. A later investigation recorded 20 attempts: 9 PASS, 6 FAIL and 5 TIMEOUT; five failures were intended detections and one was an unsuccessful directed cover. The datasets overlap and include replay/diagnostics, so their sum is not a count of independent proofs.

Raw CSVs, traces, generated solver models/logs, chat transcripts and workstation-specific paths are kept outside this source release. Their omission does not turn the recorded outcomes into newly executed proof certificates. Per-job source/configuration hashes and literal outcomes are generated again when users run the release drivers. `SOURCE_MANIFEST.json` covers the current input bytes. The current source update corrects cover metadata and portable build paths; the actual FIFO/checker `.sv` inputs remain those used in the recorded experiments.

No analog metastability probability or MTBF, eventual delivery, arbitrary runtime-reset integrity, physical board observation or completed wider integrity theorem is claimed. For integration, define reset/flush semantics, review encoding plus routed constraints, and verify the enclosing protocol. An AXI4-Lite wrapper must additionally prove AW/W pairing, stalled response stability, byte enables and actual command-completion transfer; FIFO occupancy alone is not completion.

References: [SBY task/engine documentation](https://yosyshq.readthedocs.io/projects/sby/en/latest/reference.html), [AMD multi-bit synchronizer guidance](https://docs.amd.com/r/2021.1-English/ug906-vivado-design-analysis/Multi-Bit-Synchronizer), [AMD asynchronous path constraints](https://docs.amd.com/r/2022.2-English/ug903-vivado-using-constraints/Constraining-Asynchronous-Signals).
