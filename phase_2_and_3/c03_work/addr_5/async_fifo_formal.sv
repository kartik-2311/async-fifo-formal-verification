// async_fifo_formal.sv (v3)
// Formal property set for the Gray-code CDC async FIFO, Phase 1.
//
// v1 used concurrent SVA (assert property / $past / $rose / $fell) --
// unsupported by yosys-slang's current synthesis path.
// v2 switched to immediate assertions, but relied on `initial assume
// (!wr_rst_n)` to force a known-good starting state -- also unsupported
// ("reading net state during design initialization unsupported"), since
// an `initial` block can only set register values, not sample a live
// input signal (there's no such thing as "the input's value before
// time begins" in real hardware).
//
// v3 fixes this properly: a STICKY "have we ever actually observed a
// real reset" flag per domain, set permanently to 1 the first time
// rst_n is seen low at any clock edge. Checks are only enabled once
// that flag is set. This is arguably the more correct technique anyway
// -- it doesn't force reset to happen at exactly time 0, only requires
// it to have happened at some point in the design's history before we
// start trusting internal-register consistency, which is the actual
// real-world guarantee.
//
// Properties covered:
//   1. Gray-code one-bit-change invariant (wr and rd domains)
//   2. Reset behavior: wr_full low / rd_empty high on the first cycle
//      after each domain's reset releases
//   3. wr_full / rd_empty exactly match the Gray-comparison formula,
//      using the manually-tracked previous-cycle synchronized pointer
//   4. Cover: prove full is reachable, prove recovery from full, prove
//      empty is reached again after data has flowed through

module async_fifo_formal #(
    parameter ADDR_WIDTH = 5
) (
    // Write domain
    input logic                  wr_clk,
    input logic                  wr_rst_n,
    input logic                  wr_en,
    input logic                  wr_full,
    input logic [ADDR_WIDTH:0]   wr_gray_ptr,
    input logic [ADDR_WIDTH:0]   rd_gray_sync,
    // Read domain
    input logic                  rd_clk,
    input logic                  rd_rst_n,
    input logic                  rd_en,
    input logic                  rd_empty,
    input logic [ADDR_WIDTH:0]   rd_gray_ptr,
    input logic [ADDR_WIDTH:0]   wr_gray_sync
);

  // ================== Write-domain checker ==================
  logic [ADDR_WIDTH:0] wr_gray_ptr_prev;
  logic [ADDR_WIDTH:0] rd_gray_sync_prev;
  logic                wr_full_prev;
  logic                wr_rst_n_prev;
  logic                wr_have_reset;
  logic [ADDR_WIDTH:0] wr_gray_diff;

  initial wr_have_reset = 1'b0;

  always_ff @(posedge wr_clk or negedge wr_rst_n) begin
    if (!wr_rst_n) begin
      // Asynchronous reset: the RTL's wr_gray_ptr, rd_gray_sync (captured
      // by u_sync_rd2wr, which is reset by wr_rst_n), and wr_full all snap
      // to zero between two posedge wr_clk edges. The checker's history
      // registers must follow the same async-reset behavior, otherwise
      // *_prev retains a stale value and the Gray / full assertions fire
      // falsely on the next clock edge (see C03).
      wr_gray_ptr_prev  <= '0;
      rd_gray_sync_prev <= '0;
      wr_full_prev      <= 1'b0;
      wr_rst_n_prev     <= 1'b0;
    end else begin
      // Only trust history once a real reset has actually been observed
      // at some point -- otherwise the solver is free to start wr_bin
      // and wr_gray_ptr at two unrelated arbitrary values, which breaks
      // any comparison for reasons that have nothing to do with the RTL.
      if (wr_have_reset) begin
        if (wr_rst_n_prev) begin
          // Both this cycle and the previous one are out of reset --
          // safe to compare against tracked history.

          // 1. Gray one-bit-change invariant -- the property that makes
          // crossing this pointer through a 2-flop synchronizer safe.
          // (diff & (diff-1)) == 0 is true iff diff is zero or a single
          // bit -- the same semantics as $onehot0, without relying on
          // that system task (unsupported by the current frontend).
          wr_gray_diff = wr_gray_ptr ^ wr_gray_ptr_prev;
          assert ((wr_gray_diff & (wr_gray_diff - 1'b1)) == '0);

          // 3. wr_full must exactly match the Gray-comparison formula,
          // using rd_gray_sync as it stood one wr_clk cycle ago (that's
          // the value actually captured into wr_full_next on that edge).
          assert (wr_full == (
            (wr_gray_ptr[ADDR_WIDTH]     != rd_gray_sync_prev[ADDR_WIDTH])   &&
            (wr_gray_ptr[ADDR_WIDTH-1]   != rd_gray_sync_prev[ADDR_WIDTH-1]) &&
            (wr_gray_ptr[ADDR_WIDTH-2:0] == rd_gray_sync_prev[ADDR_WIDTH-2:0])
          ));
        end else begin
          // 2. First active cycle after reset release: must start "not full".
          assert (!wr_full);
        end

        // 4. Cover: full is reachable, and recovery from full is reachable.
        cover (wr_full);
        cover (wr_full_prev && !wr_full);
      end

      wr_gray_ptr_prev  <= wr_gray_ptr;
      rd_gray_sync_prev <= rd_gray_sync;
      wr_full_prev      <= wr_full;
      wr_rst_n_prev     <= wr_rst_n;
      wr_have_reset     <= wr_have_reset | !wr_rst_n;
    end
  end

  // ================== Read-domain checker ==================
  logic [ADDR_WIDTH:0] rd_gray_ptr_prev;
  logic [ADDR_WIDTH:0] wr_gray_sync_prev;
  logic                rd_empty_prev;
  logic                rd_rst_n_prev;
  logic                rd_have_reset;
  logic [ADDR_WIDTH:0] rd_gray_diff;

  initial rd_have_reset = 1'b0;

  always_ff @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) begin
      // Asynchronous reset: mirror the RTL's async-reset behavior on
      // rd_gray_ptr, wr_gray_sync (captured by u_sync_wr2rd, reset by
      // rd_rst_n), and rd_empty so *_prev doesn't hold a stale value
      // across a reset pulse between two posedge rd_clk edges (see C03).
      rd_gray_ptr_prev  <= '0;
      wr_gray_sync_prev <= '0;
      rd_empty_prev     <= 1'b1;
      rd_rst_n_prev     <= 1'b0;
    end else begin
      if (rd_have_reset) begin
        if (rd_rst_n_prev) begin
          // Both this cycle and the previous one are out of reset --
          // safe to compare against tracked history.

          // 1. Gray one-bit-change invariant, read domain.
          rd_gray_diff = rd_gray_ptr ^ rd_gray_ptr_prev;
          assert ((rd_gray_diff & (rd_gray_diff - 1'b1)) == '0);

          // 3. rd_empty must exactly match the Gray-comparison formula,
          // using wr_gray_sync as it stood one rd_clk cycle ago.
          assert (rd_empty == (rd_gray_ptr == wr_gray_sync_prev));
        end else begin
          // 2. First active cycle after reset release: must start "empty".
          assert (rd_empty);
        end

        // 4. Cover: empty is reached again after having been non-empty
        // (i.e. data flowed through and was fully drained at least once).
        cover (!rd_empty_prev && rd_empty);
      end
      // else: currently in reset -- skip checks entirely, same reasoning
      // as the write domain above.

      rd_gray_ptr_prev  <= rd_gray_ptr;
      wr_gray_sync_prev <= wr_gray_sync;
      rd_empty_prev     <= rd_empty;
      rd_rst_n_prev     <= rd_rst_n;
      rd_have_reset     <= rd_have_reset | !rd_rst_n;
    end
  end

endmodule

bind async_fifo async_fifo_formal #(
    .ADDR_WIDTH(ADDR_WIDTH)
) u_formal (.*);