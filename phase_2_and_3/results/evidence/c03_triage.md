# C03 independent-clock triage

The pre-fix tracked blob `89e63891df735a3c9b85af5266d01062733c08a8`
fails the read-domain empty-flag checker assertion at
`formal/async_fifo_formal.sv:131` (the copied run reports the same source
line) at BMC step 9 for ADDR_WIDTH 2, 3, 4, and 5.  The archived trace shows:

1. Read reset is observed low, so the DUT resets the read pointer and empty
   flag asynchronously.
2. The old checker samples a pre-reset synchronized write-pointer/history
   value only on `posedge rd_clk`.
3. `rd_rst_n` returns high before the next relevant read-clock sample.
4. The checker compares the post-reset DUT state with that stale history and
   reports `rd_empty == (rd_gray_ptr == wr_gray_sync_prev)` false.

This is checker reset-history modeling, not an RTL counterexample.  The final
checker resets its `*_prev` state on `negedge wr_rst_n`/`negedge rd_rst_n`,
matching the DUT's asynchronous-reset behavior.  No assertion was deleted,
weakened, or replaced by an assumption.

The final candidate hashes match: `git hash-object formal/async_fifo_formal.sv`
and `git hash-object phase_2_and_3/async_fifo_formal.sv` both produced
`c40a5731b1890607e20150f4082ca4652b7df564` before the final commit.

Final reruns, `sby -f async_fifo_multiclock.sby bmc`, depth 30:

| ADDR_WIDTH | Result | elapsed |
|---:|---|---:|
| 2 | PASS | 22 s |
| 3 | PASS | 20 s |
| 4 | PASS | 31 s |
| 5 | PASS | 18 s |
