# Project rules (loaded every session, so keep this short)

Project: formal verification of a Gray-code CDC async FIFO (Yosys + yosys-slang +
SymbiYosys + z3). Phase 1 = safety props, Phase 2 = integrity harness, Phase 3 = sweep.

## Context discipline (this is why sessions used to run out)
- NEVER cat a log, VCD, CSV or INDEX. Use `grep -E`, `tail -n 20`, `head -n 30`, `wc -l`.
- Run sby, sweep.sh and any long command ONLY through:
    ./run_quiet.sh NAME -- <command>
  It writes the full log to results/evidence/NAME.log and prints a short summary.
- Mechanical work is scripted (hashes, INDEX, counts, triage extraction). Run the script
  and read its short output. Do not redo it by hand.
- Keep your final message to 10 lines or fewer.

## Session protocol
- You get exactly ONE task file. Do only that task. Do not start the next one.
- Write every result to a file named in the task. Files are the memory, not the chat.
- If you are running low on context: stop, append a 5-line handoff to STATE.md (what is
  done, what remains, exact next command), and exit.

## Hard rules
- Never weaken, delete or gate away an assertion. Never add an `assume`.
- Never modify rtl/async_fifo.sv or the original async_fifo.sv. Experiments go on copies.
- Timeout = TIMEOUT, not PASS. Unreached cover = failure. Unknown = UNKNOWN.
- Every number in a report must come from a saved log. Quote error text exactly.
- Do not commit with `git push`. Local commits are fine.
