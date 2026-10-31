// async_fifo_cdc_top.sv
// CDC structural check: the signal ENTERING each synchronizer must change by
// at most one bit per source-clock edge (Gray property, checked in the SOURCE
// domain). Wraps the unmodified async_fifo. No assume statements.
module async_fifo_cdc_top #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
) (
    input logic                  wr_clk,
    input logic                  rd_clk,
    input logic                  wr_en,
    input logic [DATA_WIDTH-1:0] wr_data,
    input logic                  rd_en
);
  // Structural reset: low until both clocks have ticked once, then high forever
  logic wr_seen, rd_seen, rst_n;
  initial begin
    wr_seen = 1'b0;
    rd_seen = 1'b0;
  end
  always_ff @(posedge wr_clk) wr_seen <= 1'b1;
  always_ff @(posedge rd_clk) rd_seen <= 1'b1;
  assign rst_n = wr_seen & rd_seen;

  logic                  wr_full, rd_empty;
  logic [DATA_WIDTH-1:0] rd_data;
  async_fifo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut (
      .wr_clk(wr_clk), .wr_rst_n(rst_n), .wr_en(wr_en), .wr_data(wr_data), .wr_full(wr_full),
      .rd_clk(rd_clk), .rd_rst_n(rst_n), .rd_en(rd_en), .rd_data(rd_data), .rd_empty(rd_empty));

  // write -> read synchronizer input, sampled in the write (source) domain
  logic [ADDR_WIDTH:0] w_prev, w_diff;
  logic                w_have;
  initial w_have = 1'b0;
  assign w_diff = dut.u_sync_wr2rd.d_in ^ w_prev;
  always_ff @(posedge wr_clk) begin
    w_prev <= dut.u_sync_wr2rd.d_in;
    w_have <= rst_n;
    if (rst_n && w_have) begin
      assert ((w_diff & (w_diff - 1'b1)) == '0);   // at most one bit changed
      cover (w_diff != '0);                        // the check sees real changes
    end
  end

  // read -> write synchronizer input, sampled in the read (source) domain
  logic [ADDR_WIDTH:0] r_prev, r_diff;
  logic                r_have;
  initial r_have = 1'b0;
  assign r_diff = dut.u_sync_rd2wr.d_in ^ r_prev;
  always_ff @(posedge rd_clk) begin
    r_prev <= dut.u_sync_rd2wr.d_in;
    r_have <= rst_n;
    if (rst_n && r_have) begin
      assert ((r_diff & (r_diff - 1'b1)) == '0);
      cover (r_diff != '0);
    end
  end
endmodule
