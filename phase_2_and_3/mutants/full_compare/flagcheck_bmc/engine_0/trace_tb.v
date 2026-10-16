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
  reg [7:0] PI_wr_data;
  reg [0:0] PI_wr_clk;
  reg [2:0] PI_tag_seq_in;
  reg [0:0] PI_rd_en;
  reg [0:0] PI_wr_en;
  reg [0:0] PI_rd_clk;
  async_fifo_integrity_top UUT (
    .wr_data(PI_wr_data),
    .wr_clk(PI_wr_clk),
    .tag_seq_in(PI_tag_seq_in),
    .rd_en(PI_rd_en),
    .wr_en(PI_wr_en),
    .rd_clk(PI_rd_clk)
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$105#sampled$471  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$111y#sampled$477  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$113#sampled$541  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$114y#sampled$491  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$119y#sampled$505  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$122y#sampled$519  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$124#sampled$527  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$125y#sampled$533  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$144y#sampled$547  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$149y#sampled$561  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$154#sampled$583  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$155y#sampled$589  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$160#sampled$597  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$163y#sampled$617  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$117_Y#sampled$377  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$121_Y#sampled$397  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$125_Y#sampled$437  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$129_Y#sampled$447  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$28_Y#sampled$407  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$32_Y#sampled$367  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$3_Y#sampled$417  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$165  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$167  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$185  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$187  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$207  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$205  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$227  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$225  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$247  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$245  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$265  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$287  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$285  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$305  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$307  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$325  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$327  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$347  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$267  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$345  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$365  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_gray_sync_prev#sampled$375  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$385  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$395  = 8'b01000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$405  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$415  = 3'b010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$425  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$435  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$603  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$445  = 3'b010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_flag_check_valid#sampled$455  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$427  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:206:execute$dut .u_mem.\mem#0#en_q$157  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:209:execute$dut .u_mem.\mem#0#addr_q$159  = 2'b00;
    // UUT.$auto$clk2fflogic.\cc:212:execute$dut .u_mem.\mem#0#data_q$161  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$356#sampled$357  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$549  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$521  = 1'b1;
    UUT.dut.u_mem.mem[2'b00] = 8'b00000000;

    // state 0
    PI_wr_data = 8'b00000010;
    PI_wr_clk = 1'b0;
    PI_tag_seq_in = 3'b010;
    PI_rd_en = 1'b1;
    PI_wr_en = 1'b0;
    PI_rd_clk = 1'b0;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b101;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
    end

    // state 2
    if (cycle == 1) begin
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b110;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b0;
    end

    // state 3
    if (cycle == 2) begin
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b000;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
    end

    // state 4
    if (cycle == 3) begin
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b110;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b0;
    end

    // state 5
    if (cycle == 4) begin
      PI_wr_data <= 8'b11111110;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b100;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b1;
    end

    // state 6
    if (cycle == 5) begin
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b011;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b0;
    end

    // state 7
    if (cycle == 6) begin
      PI_wr_data <= 8'b00100000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b000;
      PI_rd_en <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
    end

    // state 8
    if (cycle == 7) begin
      PI_wr_data <= 8'b01010110;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b110;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
    end

    // state 9
    if (cycle == 8) begin
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b110;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b0;
    end

    genclock <= cycle < 9;
    cycle <= cycle + 1;
  end
endmodule
