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
  reg [7:0] PI_wr_data;
  reg [0:0] PI_wr_en;
  reg [0:0] PI_rd_en;
  reg [0:0] PI_wr_clk;
  reg [4:0] PI_tag_seq_in;
  async_fifo_integrity_top UUT (
    .rd_clk(PI_rd_clk),
    .wr_data(PI_wr_data),
    .wr_en(PI_wr_en),
    .rd_en(PI_rd_en),
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$124y#sampled$480  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$127y#sampled$536  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$130y#sampled$508  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$135y#sampled$494  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$140y#sampled$550  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$149y#sampled$578  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$169#sampled$502  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$180#sampled$516  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$181y#sampled$522  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$199#sampled$544  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$210#sampled$572  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$216#sampled$600  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$219y#sampled$606  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$4#sampled$642  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$9#sampled$656  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$114_Y#sampled$400  = 8'b00010000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$118_Y#sampled$440  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$122_Y#sampled$450  = 5'b10100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$144_Y#sampled$420  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$148_Y#sampled$380  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$152_Y#sampled$460  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$32_Y#sampled$410  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$36_Y#sampled$370  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$168  = 5'b00001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$170  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$188  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$190  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$210  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$208  = 5'b01000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$230  = 5'b00100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$228  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$250  = 5'b11100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$248  = 5'b00001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$268  = 5'b10000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$290  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$288  = 5'b00001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$308  = 5'b10000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$310  = 5'b01000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$328  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$330  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$350  = 5'b00100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$270  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$348  = 5'b11001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$368  = 5'b00001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$378  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$662  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$388  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$398  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$408  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$418  = 5'b00001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$428  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$438  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$592  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$448  = 5'b10000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$458  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$648  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$430  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:206:execute$dut .u_mem.\mem#0#en_q$160  = 8'b00000010;
    // UUT.$auto$clk2fflogic.\cc:209:execute$dut .u_mem.\mem#0#addr_q$162  = 4'b0010;
    // UUT.$auto$clk2fflogic.\cc:212:execute$dut .u_mem.\mem#0#data_q$164  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$359#sampled$360  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$566  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$510  = 1'b0;
    UUT.dut.u_mem.mem[4'b0000] = 8'b10010000;

    // state 0
    PI_rd_clk = 1'b0;
    PI_wr_data = 8'b00000000;
    PI_wr_en = 1'b1;
    PI_rd_en = 1'b1;
    PI_wr_clk = 1'b1;
    PI_tag_seq_in = 5'b00001;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b00010000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 5'b00001;
    end

    // state 2
    if (cycle == 1) begin
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00010000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 5'b00001;
    end

    genclock <= cycle < 2;
    cycle <= cycle + 1;
  end
endmodule
