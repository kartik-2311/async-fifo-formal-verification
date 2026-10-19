# Claude Code kit: run Phase 2/3 verification without running out of context

## Why sessions died at step ~30
One long session kept everything in the conversation: a 2,500-word prompt, every command's
output, log excerpts, file contents. Context only grows, and `/compact` summarizes it lossily,
so the work stalled. The window size is fixed by the model; the fix is to use less per session.

## How this kit avoids it
1. One task per session. `driver.sh` starts a fresh `claude -p` for each task file, so context
   never accumulates across tasks. Results live in files, not in the chat.
2. Resumable. A task is skipped once its `.done/` marker exists. The marker is written only
   after a deterministic `checks/<task>.sh` passes (the model's say-so is not trusted).
3. Output discipline. `run_quiet.sh` keeps the full log on disk and prints about 5 lines.
   `triage_c03.sh` and `collect_evidence.sh` do the mechanical work with no tokens.
4. `CLAUDE.md` (short) forbids dumping logs and tells a session to hand off via STATE.md.
5. Auth-safe. Each task is a short run. On an auth error the driver stops cleanly instead of
   retrying, and `./driver.sh` resumes where it stopped after you fix the credentials.

## Use
    cd <folder containing async_fifo.sv, async_fifo_formal.sv, async_fifo_integrity_top.sv, *.sby>
    cp -r cc_kit/* .            # CLAUDE.md, tasks/, checks/, *.sh
    chmod +x *.sh checks/*.sh
    claude --help | head -40    # confirm -p, --max-turns, --allowedTools exist on your version
    ./driver.sh

Options: `MAX_TURNS=40 TRIES=3 BUDGET=5 ./driver.sh` (BUDGET maps to --max-budget-usd if your
version has it). Run one task by hand: `claude -p "$(cat tasks/T01_c03_triage.md)"` or start
`claude`, paste the task, and `/clear` before the next one.

## No repeats
- `run_quiet.sh` skips a run whose command, TIMEOUT and input files are unchanged ("CACHED").
  `FORCE=1` reruns. A 30-minute sby run is never repeated by accident.
- `driver.sh` takes a lock: a second copy exits with code 4 instead of running tasks twice.
- Before starting a task the driver runs its acceptance check; if existing outputs already
  satisfy it, the task is marked done without a session. `FRESH=1` disables this.
- CLAUDE.md forbids output variants (v2, _new, final_*): each output has one path, overwritten.

## Cleanup (task T08, or by hand)
    python3 cleanup.py                  # dry run: lists candidates, moves nothing
    python3 cleanup.py --apply          # moves them to .trash/<timestamp>/ (reversible)
    python3 cleanup.py --restore <ts>   # put them back
    python3 cleanup.py --purge          # permanent delete of .trash/ (only you run this)
It removes only untracked, uncited junk (Zone.Identifier, *.tmp, __pycache__ ...), untracked
sby work directories, triage/ scratch, empty files/folders, and files byte-identical to a
protected file. It never touches git-tracked files, sources, configs, results/, mutants/,
sweep_work/, or anything cited in summary.json, the reports or INDEX.txt. Identical files with
no protected twin are listed as REVIEW and left alone. Run the dry run and read it first.
Consider adding .trash/ .done/ logs/ triage/ .driver.lock to .gitignore.

## Task order
T00 verify the claimed C03 fix (diff, bmc/prove/cover at widths 2-5, vacuity covers) ->
T01 triage the Phase 1 multiclock failure (skip with `touch .done/T01_c03_triage .done/T02_c03_fix` if T00 says the fix is real) -> T02 fix if it is checker modeling ->
T03 find a feasible Phase 2 configuration -> T04 mutation control ->
T05 mutants M1-M5 (one session each) -> T06 reconcile summary.json + INDEX ->
T07 refresh reports -> T08 cleanup.

## If it still struggles
- In an interactive session run `/context` to see what is consuming the window.
- Lower MAX_TURNS and split a task into two task files.
- Never let a task print a log. If one does, tighten the task text, not the window.
- Auth: if you use ANTHROPIC_API_KEY, check it and its limits in the Console. If you use a
  login session, run `/login` again. The driver's exit code 3 means exactly this.

Not tested here: the real `claude` CLI and `sby` (not installed in the sandbox). The driver,
run_quiet, triage and collect scripts were tested with stub programs.
