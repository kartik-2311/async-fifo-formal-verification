// Concrete legal traffic for non-vacuity only; not an environment assumption
// for the independent-clock safety/PDR jobs, which retain free inputs.
module late_cover_driver #(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4
)(input logic wr_clk, rd_clk, input logic [ADDR_WIDTH:0] tag_seq_in, input logic choose_in);
  late_observer_top #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) checked (
    .wr_clk(wr_clk), .rd_clk(rd_clk), .wr_en(1'b1), .rd_en(1'b1),
    .wr_data({DATA_WIDTH{1'b1}}), .tag_seq_in(tag_seq_in),
    .choose_in(choose_in)
  );
endmodule
