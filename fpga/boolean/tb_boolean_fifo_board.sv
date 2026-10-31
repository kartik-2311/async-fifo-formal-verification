`timescale 1ns/1ps
module tb_boolean_fifo_board;
  reg clk=0, reset_button=0;
  wire [2:0] led;
  boolean_fifo_top dut(.clk(clk), .reset_button(reset_button), .led(led));
  always #5 clk=~clk;
  realtime t0, elapsed;
  initial begin
    wait(dut.locked===1'b1);
    repeat(5) @(posedge dut.wr_clk);
    t0=$realtime; @(posedge dut.wr_clk); elapsed=$realtime-t0;
    if(elapsed<13.30 || elapsed>13.37) $fatal(1,"Write clock is not 75 MHz: %f",elapsed);
    @(posedge dut.rd_clk); t0=$realtime;
    @(posedge dut.rd_clk); elapsed=$realtime-t0;
    if(elapsed<9.98 || elapsed>10.02) $fatal(1,"Read clock is not 100 MHz: %f",elapsed);
    wait(led[0]); #1;
    if(led[1] || dut.heartbeat==0) $fatal(1,"Board demo status/clock error");
    reset_button=1; #1;
    if(led[0] || led[1] || dut.wr_reset!=0 || dut.rd_reset!=0)
      $fatal(1,"Button did not asynchronously clear demo and reset pipelines");
    #100; reset_button=0;
    wait(led[0]); #1;
    if(led[1]) $fatal(1,"Board demo did not restart after reset");
    $display("PASS_BOARD_MMCM_RESET: 75/100 MHz, MMCM lock, startup sweep, button reset and restart");
    $finish;
  end
  initial begin #500000; $fatal(1,"Board simulation timeout"); end
endmodule
