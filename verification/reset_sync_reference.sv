// Reference integration block; the user's external reset RTL was not supplied.
// Digital async assertion / two-edge release. No analog MTBF claim.
module fifo_reset_sync(input logic clk, arst_n, output logic rst_n);
  (* ASYNC_REG = "TRUE", SHREG_EXTRACT = "NO" *) logic [1:0] release_pipe = 0;
  always_ff @(posedge clk or negedge arst_n)
    if (!arst_n) release_pipe <= 0;
    else release_pipe <= {release_pipe[0], 1'b1};
  assign rst_n = release_pipe[1];
endmodule

module reset_release_check(input logic wr_clk, rd_clk, arst_n);
  logic wr_rst_n, rd_rst_n;
  fifo_reset_sync wr_release(wr_clk, arst_n, wr_rst_n);
  fifo_reset_sync rd_release(rd_clk, arst_n, rd_rst_n);
  logic [1:0] wr_edges = 0, rd_edges = 0;
  logic ever_released = 0, reset_again = 0;
  always @(posedge wr_clk or negedge arst_n)
    if (!arst_n) wr_edges <= 0;
    else if (wr_edges < 2) wr_edges <= wr_edges + 1'b1;
  always @(posedge rd_clk or negedge arst_n)
    if (!arst_n) rd_edges <= 0;
    else if (rd_edges < 2) rd_edges <= rd_edges + 1'b1;
  always_comb begin
    assert (arst_n || (!wr_rst_n && !rd_rst_n));
    assert (!wr_rst_n || wr_edges == 2);
    assert (!rd_rst_n || rd_edges == 2);
    assert (wr_rst_n == (wr_edges == 2));
    assert (rd_rst_n == (rd_edges == 2));
  end
  always @(posedge wr_clk) begin
    if (wr_rst_n && rd_rst_n) ever_released <= 1;
    if (!arst_n && ever_released) reset_again <= 1;
    cover (wr_rst_n && rd_rst_n);
    cover (reset_again && wr_rst_n && rd_rst_n);
  end
endmodule
