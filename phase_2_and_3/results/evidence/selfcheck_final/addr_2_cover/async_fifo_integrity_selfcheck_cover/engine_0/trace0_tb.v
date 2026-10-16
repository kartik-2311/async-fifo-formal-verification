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
  reg [0:0] PI_wr_en;
  reg [0:0] PI_wr_clk;
  reg [2:0] PI_tag_seq_in;
  reg [0:0] PI_rd_en;
  reg [7:0] PI_wr_data;
  async_fifo_integrity_selfcheck UUT (
    .rd_clk(PI_rd_clk),
    .wr_en(PI_wr_en),
    .wr_clk(PI_wr_clk),
    .tag_seq_in(PI_tag_seq_in),
    .rd_en(PI_rd_en),
    .wr_data(PI_wr_data)
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$115#sampled$534  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$148#sampled$604  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$160#sampled$618  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$101_Y#sampled$466  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$105_Y#sampled$486  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$108_Y#sampled$406  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$111_Y#sampled$436  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$23_Y#sampled$426  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$27_Y#sampled$356  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$30_Y#sampled$346  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$34_Y#sampled$366  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$90_Y#sampled$416  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$94_Y#sampled$456  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$98_Y#sampled$476  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$144  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$146  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$164  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$166  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$186  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$184  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$206  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_rst_n#sampled$496  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$204  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$226  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$224  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$244  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$266  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$264  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$284  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$286  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$304  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$306  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$326  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$246  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$324  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_after_first_wr#sampled$344  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$354  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_first_armed#sampled$364  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_rst_n_prev#sampled$374  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_rst_n_prev#sampled$596  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$396  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen_prev#sampled$394  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen_prev#sampled$568  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_capture_value#sampled$404  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$414  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$424  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$434  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$506  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$454  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_after_first_rd#sampled$464  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$474  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_first_armed#sampled$484  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_rst_n_prev#sampled$494  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_rst_n_prev#sampled$526  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_seen_prev#sampled$504  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_seen_prev#sampled$652  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$590  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:206:execute$dut .u_mem.\mem#0#en_q$136  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:209:execute$dut .u_mem.\mem#0#addr_q$138  = 2'b00;
    // UUT.$auto$clk2fflogic.\cc:212:execute$dut .u_mem.\mem#0#data_q$140  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$335#sampled$336  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$556  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$528  = 1'b1;
    UUT.dut.u_mem.mem[2'b00] = 8'b00000000;

    // state 0
    PI_rd_clk = 1'b0;
    PI_wr_en = 1'b0;
    PI_wr_clk = 1'b0;
    PI_tag_seq_in = 3'b000;
    PI_rd_en = 1'b0;
    PI_wr_data = 8'b00000000;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b000;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
    end

    genclock <= cycle < 1;
    cycle <= cycle + 1;
  end
endmodule
