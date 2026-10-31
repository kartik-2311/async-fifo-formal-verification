`timescale 1ns/1ps
module boolean_fifo_top(input wire clk, reset_button, output wire [2:0] led);
  wire feedback, feedback_buf, wr_raw, rd_raw, wr_clk, rd_clk, locked;
  // Confirmed Boolean 100 MHz oscillator -> 600 MHz VCO -> 75 / 100 MHz.
  MMCME2_BASE #(.CLKIN1_PERIOD(10.0), .CLKFBOUT_MULT_F(6.0),
    .DIVCLK_DIVIDE(1), .CLKOUT0_DIVIDE_F(8.0), .CLKOUT1_DIVIDE(6)) clocks(
    .CLKIN1(clk), .CLKFBIN(feedback_buf), .CLKFBOUT(feedback),
    .CLKOUT0(wr_raw), .CLKOUT1(rd_raw), .LOCKED(locked), .PWRDWN(1'b0), .RST(1'b0));
  BUFG fb_clock(.I(feedback), .O(feedback_buf));
  BUFG write_clock(.I(wr_raw), .O(wr_clk));
  BUFG read_clock(.I(rd_raw), .O(rd_clk));
  wire reset_async = reset_button || !locked;
  (* ASYNC_REG="TRUE", SHREG_EXTRACT="NO" *) reg [1:0] wr_reset=0, rd_reset=0;
  always @(posedge wr_clk or posedge reset_async)
    if(reset_async) wr_reset<=0; else wr_reset<={wr_reset[0],1'b1};
  always @(posedge rd_clk or posedge reset_async)
    if(reset_async) rd_reset<=0; else rd_reset<={rd_reset[0],1'b1};
  reg [26:0] heartbeat=0;
  always @(posedge rd_clk) heartbeat<=heartbeat+1'b1;
  assign led[2]=heartbeat[26];
  fifo_smoke demo(.wr_clk(wr_clk), .rd_clk(rd_clk),
    .wr_rst_n(wr_reset[1]), .rd_rst_n(rd_reset[1]), .passed(led[0]), .failed(led[1]));
endmodule
