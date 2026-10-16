module async_fifo_integrity_max_tag_width5 (
    input logic wr_clk,
    input logic rd_clk,
    input logic wr_en,
    input logic wr_data,
    input logic rd_en
);
  async_fifo_integrity_selfcheck #(
      .DATA_WIDTH(1),
      .ADDR_WIDTH(5)
  ) u_checker (
      .wr_clk(wr_clk),
      .rd_clk(rd_clk),
      .wr_en(wr_en),
      .wr_data(wr_data),
      .rd_en(rd_en),
      .tag_seq_in(6'b111111)
  );
endmodule
