`ifndef VERILATOR
module testbench;
  reg [4095:0] vcdfile;
  reg clock;
`else
module testbench(input clock, output reg genclock);
  initial genclock = 1;
`endif
  reg genclock = 1;
  reg [31:0] cycle = 0;
  reg [0:0] PI_rd_clk;
  reg [0:0] PI_rd_en;
  reg [7:0] PI_wr_data;
  reg [0:0] PI_wr_en;
  reg [0:0] PI_wr_clk;
  reg [2:0] PI_tag_seq_in;
  async_fifo_integrity_selfcheck UUT (
    .rd_clk(PI_rd_clk),
    .rd_en(PI_rd_en),
    .wr_data(PI_wr_data),
    .wr_en(PI_wr_en),
    .wr_clk(PI_wr_clk),
    .tag_seq_in(PI_tag_seq_in)
  );
`ifndef VERILATOR
  initial begin
    if ($value$plusargs("vcd=%s", vcdfile)) begin
      $dumpfile(vcdfile);
      $dumpvars(0, testbench);
    end
    #5 clock = 0;
    while (genclock) begin
      #5 clock = 0;
      #5 clock = 1;
    end
  end
`endif
  initial begin
`ifndef VERILATOR
    #1;
`endif
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$168#sampled$672  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$177y#sampled$678  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$185#sampled$728  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$193y#sampled$748  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$220#sampled$756  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$237#sampled$798  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$255#sampled$840  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$checked .\rd_cnt$198#sampled$404  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$checked .\rd_reset_done$7#sampled$414  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$checked .\tag_data$162#sampled$434  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$checked .\tag_read$199#sampled$444  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$checked .\tag_seq$15#sampled$454  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$checked .\tag_written$161#sampled$474  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$checked .\wr_cnt$160#sampled$484  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$checked .\wr_reset_done$2#sampled$494  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$139_Y#sampled$524  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$142_Y#sampled$504  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$145_Y#sampled$514  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$156_Y#sampled$574  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$159_Y#sampled$554  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$163_Y#sampled$564  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$165_Y#sampled$544  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$167_Y#sampled$534  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_rd_ptr.\rd_bin#sampled$202  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_rd_ptr.\rd_bin_next#sampled$204  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_rd_ptr.\rd_empty#sampled$222  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_rd_ptr.\rd_empty_next#sampled$224  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_rd_ptr.\rd_gray_next#sampled$244  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_rd_ptr.\rd_gray_ptr#sampled$242  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_rd_ptr.\rd_gray_ptr#sampled$264  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_sync_rd2wr.\meta_ff#sampled$262  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_sync_rd2wr.\meta_ff#sampled$284  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_sync_rd2wr.\sync_ff#sampled$282  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_sync_wr2rd.\meta_ff#sampled$302  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_sync_wr2rd.\meta_ff#sampled$324  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_sync_wr2rd.\sync_ff#sampled$322  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_wr_ptr.\wr_bin#sampled$342  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_wr_ptr.\wr_bin_next#sampled$344  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_wr_ptr.\wr_full#sampled$362  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_wr_ptr.\wr_full_next#sampled$364  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_wr_ptr.\wr_gray_next#sampled$384  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_wr_ptr.\wr_gray_ptr#sampled$304  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .dut.u_wr_ptr.\wr_gray_ptr#sampled$382  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .\rd_cnt#sampled$402  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .\rd_reset_done#sampled$412  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .\rd_seen#sampled$422  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .\tag_data#sampled$432  = 8'b00010000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .\tag_read#sampled$442  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .\tag_seq#sampled$452  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .\tag_set#sampled$462  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .\tag_written#sampled$472  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .\tag_written#sampled$734  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .\wr_cnt#sampled$482  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/checked .\wr_reset_done#sampled$492  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_after_first_wr#sampled$502  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_first_armed#sampled$512  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_high_seen#sampled$522  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_high_seen#sampled$832  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_capture_valid#sampled$532  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_capture_value#sampled$542  = 3'b010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_after_first_rd#sampled$552  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_first_armed#sampled$562  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_high_seen#sampled$572  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_high_seen#sampled$790  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$464  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$393#sampled$394  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$526  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$546  = 1'b1;

    // state 0
    PI_rd_clk = 1'b0;
    PI_rd_en = 1'b0;
    PI_wr_data = 8'b00000001;
    PI_wr_en = 1'b0;
    PI_wr_clk = 1'b0;
    PI_tag_seq_in = 3'b000;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000001;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b001;
    end

    // state 2
    if (cycle == 1) begin
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000001;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b001;
    end

    // state 3
    if (cycle == 2) begin
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000001;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b001;
    end

    genclock <= cycle < 3;
    cycle <= cycle + 1;
  end
endmodule
