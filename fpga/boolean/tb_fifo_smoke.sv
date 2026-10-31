`timescale 1ns/1ps
module tb_fifo_smoke;
  reg wr_clk=0, rd_clk=0, wr_rst_n=0, rd_rst_n=0;
  wire passed, failed;
  always #6.666667 wr_clk=~wr_clk;
  always #5 rd_clk=~rd_clk;
  fifo_smoke dut(.wr_clk(wr_clk), .rd_clk(rd_clk), .wr_rst_n(wr_rst_n),
                 .rd_rst_n(rd_rst_n), .passed(passed), .failed(failed));
  integer full_cycles=0, empty_cycles=0, writes=0, reads=0;
  reg [7:0] injected;
  reg injection_active=0;
  always @(posedge wr_clk) if(wr_rst_n) begin
    if(dut.wr_full) full_cycles=full_cycles+1;
    if(dut.wr_en && !dut.wr_full) writes=writes+1;
  end
  always @(posedge rd_clk) if(rd_rst_n) begin
    if(dut.rd_empty) empty_cycles=empty_cycles+1;
    if(dut.rd_en && !dut.rd_empty) reads=reads+1;
    #0.001;
    if(failed && !injection_active) $fatal(1,"Unexpected data failure");
  end
  initial begin
    #80;
    @(negedge wr_clk); wr_rst_n=1;
    @(negedge rd_clk); rd_rst_n=1;
    wait(passed); #1;
    if(failed || reads<1024 || full_cycles<1 || empty_cycles<1)
      $fatal(1,"Insufficient full/empty/wrap coverage");
    $display("PASS initial sweep: reads=%0d writes=%0d full_stalls=%0d empty_cycles=%0d", reads,writes,full_cycles,empty_cycles);
    // A shared reset intentionally flushes and restarts this test session.
    wr_rst_n=0; rd_rst_n=0;
    #1;
    if(passed || failed) $fatal(1,"Reset did not clear status");
    #80;
    @(negedge wr_clk); wr_rst_n=1;
    repeat(3) @(negedge rd_clk);
    rd_rst_n=1;
    wait(passed); #1;
    if(failed) $fatal(1,"Reset/restart failed");
    @(negedge rd_clk);
    while(!(dut.rd_en && !dut.rd_empty)) @(negedge rd_clk);
    injection_active=1;
    injected=dut.expected_data ^ 8'h01;
    force dut.rd_data=injected;
    @(posedge rd_clk); #1;
    release dut.rd_data;
    // Comparison is deliberately pipelined one local read-clock cycle.
    @(posedge rd_clk); #1;
    if(!failed) $fatal(1,"Injected mismatch was not detected after comparison latency");
    repeat(20) @(posedge rd_clk);
    if(!failed) $fatal(1,"Error status is not sticky");
    $display("PASS reset/restart, stalls, many wraps and injected data corruption detection");
    $finish;
  end
  initial begin #300000; $fatal(1,"Smoke-test watchdog expired"); end
endmodule
