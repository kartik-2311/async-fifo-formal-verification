// async_fifo_integrity_top.sv
// Phase 2: data-integrity proof for the Gray-code async FIFO.
//
// Formal top level. Wraps the unmodified async_fifo, drives it with free
// inputs, and checks it with a "tagged item" scoreboard.
//
// HOW THE CHECK WORKS
//   The solver picks ONE sequence number (tag_seq) and holds it fixed. The
//   checker counts accepted writes (wr_cnt) and accepted reads (rd_cnt)
//   independently of the DUT's own pointers. When write number tag_seq
//   happens, its data is captured. When read number tag_seq happens, the
//   data coming out of the FIFO must equal what was captured. Because
//   tag_seq can be any value, this covers every position in the stream:
//   a dropped, duplicated, reordered, overwritten or stale item shifts the
//   numbering and produces a mismatch.
//
//   tag_seq has ADDR_WIDTH+1 bits, so it spans two full laps of the memory
//   (every slot is exercised twice, and every pointer wrap state is hit).
//   Items beyond 2**(ADDR_WIDTH+1) alias onto the same tag values and are
//   not individually tracked. State that limit in the paper.
//
// ENVIRONMENT ASSUMPTIONS (built structurally, no assume statements)
//   1. wr_clk and rd_clk are free: any ratio, any phase (needs the
//      `multiclock on` option in the .sby file).
//   2. One shared reset, held low until BOTH clocks have ticked at least
//      once, then released and never asserted again.
//   3. Reset release timing relative to the clocks is not modeled
//      (recovery/removal is a physical-design concern).
//   4. wr_en, wr_data, rd_en are completely free every step.
//
// PROPERTIES
//   P2a  no overflow : an accepted write never happens when the FIFO holds
//                      DEPTH items
//   P2b  no underflow: an accepted read never happens when it holds 0 items
//   P2c  integrity   : the tag_seq-th item read equals the tag_seq-th item
//                      written (covers ordering, loss, duplication,
//                      overwrite)
//   P2d  full flag   : wr_full_next matches the Gray-pointer comparison
//   Covers prove the tagged check actually fires, on the second lap too.

module async_fifo_integrity_top #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 2
) (
    input logic                  wr_clk,
    input logic                  rd_clk,
    input logic                  wr_en,
    input logic [DATA_WIDTH-1:0] wr_data,
    input logic                  rd_en,
    input logic [ADDR_WIDTH:0]   tag_seq_in   // free; sampled once, then frozen
);

  localparam SEQ_W = ADDR_WIDTH + 1;
  localparam int DEPTH = 1 << ADDR_WIDTH;

  // ------------------------------------------------------------------
  // Structural reset: low until both clocks have ticked once, then high
  // forever. Each domain therefore sees at least one edge while in reset.
  // ------------------------------------------------------------------
  logic wr_seen;
  logic rd_seen;
  logic wr_reset_done;
  logic rd_reset_done;
  logic rst_n;
  initial begin
    wr_seen = 1'b0;
    rd_seen = 1'b0;
    wr_reset_done = 1'b0;
    rd_reset_done = 1'b0;
  end
  always_ff @(posedge wr_clk) begin
    wr_seen <= 1'b1;
    if (!rst_n)
      wr_reset_done <= 1'b1;
    if (wr_seen)
      assert (wr_reset_done);
  end
  always_ff @(posedge rd_clk) begin
    rd_seen <= 1'b1;
    if (!rst_n)
      rd_reset_done <= 1'b1;
    if (rd_seen)
      assert (rd_reset_done);
  end

  assign rst_n = wr_seen & rd_seen;

  always_comb begin
    assert (!wr_seen || wr_reset_done);
    assert (!rd_seen || rd_reset_done);
  end

  // ------------------------------------------------------------------
  // Frozen tag index: take a free input at the first write-clock edge,
  // then never change it. Behaves like an "any constant" without needing
  // a frontend-specific attribute.
  // ------------------------------------------------------------------
  logic             tag_set;
  logic [SEQ_W-1:0] tag_seq;
  initial tag_set = 1'b0;
  always_ff @(posedge wr_clk) begin
    if (!tag_set) begin
      tag_seq <= tag_seq_in;
      tag_set <= 1'b1;
    end
  end

  // ------------------------------------------------------------------
  // Device under test (unmodified)
  // ------------------------------------------------------------------
  logic                  wr_full;
  logic                  rd_empty;
  logic [DATA_WIDTH-1:0] rd_data;

  async_fifo #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) dut (
      .wr_clk  (wr_clk),
      .wr_rst_n(rst_n),
      .wr_en   (wr_en),
      .wr_data (wr_data),
      .wr_full (wr_full),
      .rd_clk  (rd_clk),
      .rd_rst_n(rst_n),
      .rd_en   (rd_en),
      .rd_data (rd_data),
      .rd_empty(rd_empty)
  );

  // Accepted operations, as seen at the clock edge (pre-edge flag values)
  logic wr_acc;
  logic rd_acc;
  assign wr_acc = wr_en & ~wr_full;
  assign rd_acc = rd_en & ~rd_empty;

  // ------------------------------------------------------------------
  // Scoreboard state
  // ------------------------------------------------------------------
  logic [SEQ_W-1:0]      wr_cnt;        // accepted writes since reset
  logic [SEQ_W-1:0]      rd_cnt;        // accepted reads since reset
  logic                  tag_written;
  logic                  tag_read;
  logic [DATA_WIDTH-1:0] tag_data;

  // Occupancy, forced to SEQ_W bits so the subtraction wraps correctly
  logic [SEQ_W-1:0] occ;
  assign occ = wr_cnt - rd_cnt;

  always_comb begin
    if (rst_n && wr_reset_done && rd_reset_done &&
        tag_written && !tag_read) begin
      assert (wr_cnt != rd_cnt);
      assert (dut.u_mem.mem[tag_seq[ADDR_WIDTH-1:0]] == tag_data);
    end
  end

  always_comb begin
    assert (dut.u_wr_ptr.wr_full_next ==
            ((dut.u_wr_ptr.wr_gray_next[ADDR_WIDTH] !=
              dut.rd_gray_sync[ADDR_WIDTH]) &&
             (dut.u_wr_ptr.wr_gray_next[ADDR_WIDTH-1] !=
              dut.rd_gray_sync[ADDR_WIDTH-1]) &&
             (dut.u_wr_ptr.wr_gray_next[ADDR_WIDTH-2:0] ==
              dut.rd_gray_sync[ADDR_WIDTH-2:0])));
  end

  // ---- Write side ----
  always_ff @(posedge wr_clk) begin
    if (!rst_n || !wr_reset_done) begin
      wr_cnt      <= '0;
      tag_written <= 1'b0;
      tag_data    <= '0;
    end else begin
      assert (wr_cnt == dut.u_wr_ptr.wr_bin);
      assert (dut.wr_gray_ptr ==
              (dut.u_wr_ptr.wr_bin ^ (dut.u_wr_ptr.wr_bin >> 1)));
      assert (occ <= DEPTH);

      if (wr_acc) begin
        // P2a: no overflow
        assert (occ < DEPTH);

        if (!tag_written && wr_cnt == tag_seq) begin
          tag_written <= 1'b1;
          tag_data    <= wr_data;
        end
        wr_cnt <= wr_cnt + 1'b1;
      end
    end
  end

  // ---- Read side ----
  // rd_data is a combinational read of the slot at the CURRENT read
  // pointer, so the item being popped at this edge is the pre-edge value.
  always_ff @(posedge rd_clk) begin
    if (!rst_n || !rd_reset_done) begin
      rd_cnt   <= '0;
      tag_read <= 1'b0;
    end else begin
      assert (rd_cnt == dut.u_rd_ptr.rd_bin);
      assert (dut.rd_gray_ptr ==
              (dut.u_rd_ptr.rd_bin ^ (dut.u_rd_ptr.rd_bin >> 1)));

      // Both pointers have wrapped past the first lap
      cover (wr_cnt[ADDR_WIDTH] && rd_cnt[ADDR_WIDTH]);

      if (rd_acc) begin
        // P2b: no underflow
        assert (wr_cnt != rd_cnt);

        if (!tag_read && rd_cnt == tag_seq) begin
          // P2c: integrity, ordering, no loss, no duplication
          assert (tag_written);
          assert (rd_data == tag_data);

          // Non-vacuity: the tagged check really fires
          cover (tag_written);
          cover (tag_written && tag_seq[ADDR_WIDTH]);
          tag_read <= 1'b1;
        end
        rd_cnt <= rd_cnt + 1'b1;
      end
    end
  end

endmodule
