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
  reg [0:0] PI_rd_en;
  reg [4:0] PI_tag_seq_in;
  reg [0:0] PI_wr_en;
  reg [0:0] PI_wr_clk;
  async_fifo_integrity_top UUT (
    .rd_clk(PI_rd_clk),
    .wr_data(PI_wr_data),
    .rd_en(PI_rd_en),
    .tag_seq_in(PI_tag_seq_in),
    .wr_en(PI_wr_en),
    .wr_clk(PI_wr_clk)
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$127y#sampled$568  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$147#sampled$492  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$148y#sampled$470  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$153y#sampled$484  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$156y#sampled$498  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$158#sampled$506  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$159y#sampled$512  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$177#sampled$534  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$178y#sampled$526  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$183y#sampled$540  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$188#sampled$562  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$194#sampled$590  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$197y#sampled$596  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$4#sampled$632  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$9#sampled$646  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$104_Y#sampled$390  = 8'b11001000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$108_Y#sampled$430  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$112_Y#sampled$440  = 5'b10001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$134_Y#sampled$410  = 5'b10010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$138_Y#sampled$370  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$142_Y#sampled$450  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$22_Y#sampled$400  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$26_Y#sampled$360  = 5'b10010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$158  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$160  = 5'b10010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$178  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$180  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$200  = 5'b11011;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$198  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$220  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$218  = 5'b00010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$240  = 5'b11011;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$238  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$258  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$280  = 5'b01000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$278  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$298  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$300  = 5'b10010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$318  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$320  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$340  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$260  = 5'b10000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$338  = 5'b10000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$358  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$368  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$652  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$378  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$388  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$398  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$408  = 5'b10000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$418  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$428  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$582  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$438  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$448  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$638  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$420  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:206:execute$dut .u_mem.\mem#0#en_q$150  = 8'b11111111;
    // UUT.$auto$clk2fflogic.\cc:209:execute$dut .u_mem.\mem#0#addr_q$152  = 4'b1000;
    // UUT.$auto$clk2fflogic.\cc:212:execute$dut .u_mem.\mem#0#data_q$154  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$349#sampled$350  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$556  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$500  = 1'b0;
    UUT.dut.u_mem.mem[4'b0010] = 8'b10001000;
    UUT.dut.u_mem.mem[4'b0011] = 8'b00000000;

    // state 0
    PI_rd_clk = 1'b1;
    PI_wr_data = 8'b00000000;
    PI_rd_en = 1'b1;
    PI_tag_seq_in = 5'b00000;
    PI_wr_en = 1'b0;
    PI_wr_clk = 1'b1;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b00000001;
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 2
    if (cycle == 1) begin
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b01100100;
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 3
    if (cycle == 2) begin
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b11001000;
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 5'b00001;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 4
    if (cycle == 3) begin
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b11001000;
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    genclock <= cycle < 4;
    cycle <= cycle + 1;
  end
endmodule
