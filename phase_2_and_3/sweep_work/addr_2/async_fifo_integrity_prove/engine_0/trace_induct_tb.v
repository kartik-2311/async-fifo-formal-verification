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
  reg [0:0] PI_rd_clk;
  reg [0:0] PI_rd_en;
  reg [0:0] PI_wr_clk;
  reg [2:0] PI_tag_seq_in;
  reg [0:0] PI_wr_en;
  async_fifo_integrity_top UUT (
    .wr_data(PI_wr_data),
    .rd_clk(PI_rd_clk),
    .rd_en(PI_rd_en),
    .wr_clk(PI_wr_clk),
    .tag_seq_in(PI_tag_seq_in),
    .wr_en(PI_wr_en)
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$194#sampled$590  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$197y#sampled$596  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$4#sampled$632  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$9#sampled$646  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$104_Y#sampled$390  = 8'b00001000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$108_Y#sampled$430  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$112_Y#sampled$440  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$134_Y#sampled$410  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$138_Y#sampled$370  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$142_Y#sampled$450  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$22_Y#sampled$400  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$26_Y#sampled$360  = 3'b010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$158  = 3'b111;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$160  = 3'b010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$178  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$180  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$200  = 3'b011;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$198  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$220  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$218  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$240  = 3'b101;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$238  = 3'b110;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$258  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$280  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$278  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$298  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$300  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$318  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$320  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$340  = 3'b011;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$260  = 3'b110;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$338  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$358  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$368  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$652  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$378  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$388  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$398  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$408  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$418  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$428  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$582  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$438  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$448  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$638  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$420  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:206:execute$dut .u_mem.\mem#0#en_q$150  = 8'b00000100;
    // UUT.$auto$clk2fflogic.\cc:209:execute$dut .u_mem.\mem#0#addr_q$152  = 2'b10;
    // UUT.$auto$clk2fflogic.\cc:212:execute$dut .u_mem.\mem#0#data_q$154  = 8'b00000100;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$349#sampled$350  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$556  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$500  = 1'b0;
    UUT.dut.u_mem.mem[2'b10] = 8'b00000100;
    UUT.dut.u_mem.mem[2'b00] = 8'b11111111;
    UUT.dut.u_mem.mem[2'b11] = 8'b00000011;
    UUT.dut.u_mem.mem[2'b01] = 8'b11111111;

    // state 0
    PI_wr_data = 8'b00010000;
    PI_rd_clk = 1'b1;
    PI_rd_en = 1'b0;
    PI_wr_clk = 1'b1;
    PI_tag_seq_in = 3'b000;
    PI_wr_en = 1'b1;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_wr_data <= 8'b01000000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b100;
      PI_wr_en <= 1'b0;
    end

    // state 2
    if (cycle == 1) begin
      PI_wr_data <= 8'b01001000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b000;
      PI_wr_en <= 1'b1;
    end

    // state 3
    if (cycle == 2) begin
      PI_wr_data <= 8'b00000100;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b1;
    end

    // state 4
    if (cycle == 3) begin
      PI_wr_data <= 8'b00000100;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b100;
      PI_wr_en <= 1'b0;
    end

    // state 5
    if (cycle == 4) begin
      PI_wr_data <= 8'b00000100;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b1;
    end

    // state 6
    if (cycle == 5) begin
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b1;
    end

    // state 7
    if (cycle == 6) begin
      PI_wr_data <= 8'b00100000;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b100;
      PI_wr_en <= 1'b1;
    end

    // state 8
    if (cycle == 7) begin
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b1;
    end

    // state 9
    if (cycle == 8) begin
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b1;
    end

    // state 10
    if (cycle == 9) begin
      PI_wr_data <= 8'b00010000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b100;
      PI_wr_en <= 1'b1;
    end

    // state 11
    if (cycle == 10) begin
      PI_wr_data <= 8'b10000000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b1;
    end

    // state 12
    if (cycle == 11) begin
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b1;
    end

    // state 13
    if (cycle == 12) begin
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b1;
    end

    // state 14
    if (cycle == 13) begin
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b0;
    end

    // state 15
    if (cycle == 14) begin
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b1;
    end

    // state 16
    if (cycle == 15) begin
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b1;
    end

    // state 17
    if (cycle == 16) begin
      PI_wr_data <= 8'b01000000;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b000;
      PI_wr_en <= 1'b1;
    end

    // state 18
    if (cycle == 17) begin
      PI_wr_data <= 8'b00100000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b1;
    end

    // state 19
    if (cycle == 18) begin
      PI_wr_data <= 8'b00000111;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b1;
    end

    // state 20
    if (cycle == 19) begin
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b0;
    end

    // state 21
    if (cycle == 20) begin
      PI_wr_data <= 8'b00000100;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b1;
    end

    // state 22
    if (cycle == 21) begin
      PI_wr_data <= 8'b00000100;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b100;
      PI_wr_en <= 1'b1;
    end

    // state 23
    if (cycle == 22) begin
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b1;
    end

    // state 24
    if (cycle == 23) begin
      PI_wr_data <= 8'b00000100;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b1;
    end

    // state 25
    if (cycle == 24) begin
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b1;
    end

    // state 26
    if (cycle == 25) begin
      PI_wr_data <= 8'b00000110;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b1;
    end

    // state 27
    if (cycle == 26) begin
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b1;
    end

    // state 28
    if (cycle == 27) begin
      PI_wr_data <= 8'b00000010;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b100;
      PI_wr_en <= 1'b1;
    end

    // state 29
    if (cycle == 28) begin
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b1;
    end

    // state 30
    if (cycle == 29) begin
      PI_wr_data <= 8'b00000001;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b000;
      PI_wr_en <= 1'b1;
    end

    // state 31
    if (cycle == 30) begin
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b0;
    end

    // state 32
    if (cycle == 31) begin
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b010;
      PI_wr_en <= 1'b1;
    end

    genclock <= cycle < 32;
    cycle <= cycle + 1;
  end
endmodule
