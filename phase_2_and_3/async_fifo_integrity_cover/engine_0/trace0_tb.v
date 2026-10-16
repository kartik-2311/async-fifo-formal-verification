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
  reg [0:0] PI_rd_en;
  reg [0:0] PI_wr_en;
  reg [0:0] PI_rd_clk;
  reg [0:0] PI_wr_clk;
  reg [7:0] PI_wr_data;
  reg [4:0] PI_tag_seq_in;
  async_fifo_integrity_top UUT (
    .rd_en(PI_rd_en),
    .wr_en(PI_wr_en),
    .rd_clk(PI_rd_clk),
    .wr_clk(PI_wr_clk),
    .wr_data(PI_wr_data),
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$219#sampled$678  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$228y#sampled$684  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$236#sampled$734  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$244y#sampled$754  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$138_Y#sampled$444  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$142_Y#sampled$484  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$146_Y#sampled$494  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$14_Y#sampled$514  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$168_Y#sampled$464  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$172_Y#sampled$424  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$176_Y#sampled$524  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$17_Y#sampled$504  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$2_Y#sampled$414  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$56_Y#sampled$454  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$5_Y#sampled$404  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$60_Y#sampled$394  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$192  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$194  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$212  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$214  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$234  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$232  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$254  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$252  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$274  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$272  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$292  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$314  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$312  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$332  = 5'b00001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$334  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$352  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$354  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$374  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$294  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$372  = 5'b00001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$392  = 5'b00010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_gray_sampled_for_wr#sampled$402  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_meta_sampled_for_wr#sampled$412  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$422  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$432  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$442  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$452  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$462  = 5'b00001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$472  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$482  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$740  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$492  = 5'b10111;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_gray_sampled_for_rd#sampled$502  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_meta_sampled_for_rd#sampled$512  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$522  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$226  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$283#sampled$284  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$396  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$376  = 1'b1;

    // state 0
    PI_rd_en = 1'b1;
    PI_wr_en = 1'b0;
    PI_rd_clk = 1'b0;
    PI_wr_clk = 1'b0;
    PI_wr_data = 8'b00000001;
    PI_tag_seq_in = 5'b00000;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b1;
      PI_wr_data <= 8'b00001000;
      PI_tag_seq_in <= 5'b01000;
    end

    // state 2
    if (cycle == 1) begin
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_tag_seq_in <= 5'b00000;
    end

    // state 3
    if (cycle == 2) begin
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_tag_seq_in <= 5'b00001;
    end

    // state 4
    if (cycle == 3) begin
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_wr_data <= 8'b00010000;
      PI_tag_seq_in <= 5'b00100;
    end

    // state 5
    if (cycle == 4) begin
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_wr_data <= 8'b01000000;
      PI_tag_seq_in <= 5'b00000;
    end

    // state 6
    if (cycle == 5) begin
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_wr_data <= 8'b00000001;
      PI_tag_seq_in <= 5'b00001;
    end

    // state 7
    if (cycle == 6) begin
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_tag_seq_in <= 5'b00001;
    end

    // state 8
    if (cycle == 7) begin
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_wr_data <= 8'b00000001;
      PI_tag_seq_in <= 5'b00010;
    end

    // state 9
    if (cycle == 8) begin
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_tag_seq_in <= 5'b01000;
    end

    // state 10
    if (cycle == 9) begin
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_wr_data <= 8'b00000001;
      PI_tag_seq_in <= 5'b00000;
    end

    genclock <= cycle < 10;
    cycle <= cycle + 1;
  end
endmodule
