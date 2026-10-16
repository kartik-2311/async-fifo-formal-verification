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
  reg [3:0] PI_tag_seq_in;
  reg [0:0] PI_wr_clk;
  reg [0:0] PI_wr_en;
  reg [0:0] PI_rd_clk;
  reg [7:0] PI_wr_data;
  async_fifo_integrity_top UUT (
    .rd_en(PI_rd_en),
    .tag_seq_in(PI_tag_seq_in),
    .wr_clk(PI_wr_clk),
    .wr_en(PI_wr_en),
    .rd_clk(PI_rd_clk),
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$118y#sampled$568  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$138#sampled$492  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$139y#sampled$470  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$144y#sampled$484  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$147y#sampled$498  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$149#sampled$506  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$150y#sampled$512  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$168#sampled$534  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$169y#sampled$526  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$174y#sampled$540  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$179#sampled$562  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$185#sampled$590  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$188y#sampled$596  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$4#sampled$632  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$9#sampled$646  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$104_Y#sampled$390  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$108_Y#sampled$430  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$112_Y#sampled$440  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$134_Y#sampled$410  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$138_Y#sampled$370  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$142_Y#sampled$450  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$22_Y#sampled$400  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$26_Y#sampled$360  = 4'b0011;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$158  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$160  = 4'b1100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$178  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$180  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$200  = 4'b0010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$198  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$220  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$218  = 4'b0100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$240  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$238  = 4'b1110;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$258  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$280  = 4'b0010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$278  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$298  = 4'b1010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$300  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$318  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$320  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$340  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$260  = 4'b0001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$338  = 4'b0010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$358  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$368  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$652  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$378  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$388  = 8'b00100000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$398  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$408  = 4'b1110;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$418  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$428  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$582  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$438  = 4'b1110;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$448  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$638  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$420  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:206:execute$dut .u_mem.\mem#0#en_q$150  = 8'b00000010;
    // UUT.$auto$clk2fflogic.\cc:209:execute$dut .u_mem.\mem#0#addr_q$152  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:212:execute$dut .u_mem.\mem#0#data_q$154  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$349#sampled$350  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$556  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$500  = 1'b1;
    UUT.dut.u_mem.mem[3'b000] = 8'b00001100;
    UUT.dut.u_mem.mem[3'b110] = 8'b00001100;

    // state 0
    PI_rd_en = 1'b1;
    PI_tag_seq_in = 4'b1110;
    PI_wr_clk = 1'b1;
    PI_wr_en = 1'b0;
    PI_rd_clk = 1'b1;
    PI_wr_data = 8'b00000000;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0000;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b10000001;
    end

    // state 2
    if (cycle == 1) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0001;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 3
    if (cycle == 2) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0100;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 4
    if (cycle == 3) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0100;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 5
    if (cycle == 4) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0110;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 6
    if (cycle == 5) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b1000;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 7
    if (cycle == 6) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0011;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 8
    if (cycle == 7) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0011;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 9
    if (cycle == 8) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0001;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 10
    if (cycle == 9) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0000;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 11
    if (cycle == 10) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0001;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 12
    if (cycle == 11) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0100;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 13
    if (cycle == 12) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b1000;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 14
    if (cycle == 13) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0001;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000001;
    end

    // state 15
    if (cycle == 14) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0001;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 16
    if (cycle == 15) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b1000;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 17
    if (cycle == 16) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0001;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 18
    if (cycle == 17) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b1010;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 19
    if (cycle == 18) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b1010;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 20
    if (cycle == 19) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0000;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 21
    if (cycle == 20) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b1010;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 22
    if (cycle == 21) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0000;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 23
    if (cycle == 22) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0100;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 24
    if (cycle == 23) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b1000;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 25
    if (cycle == 24) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0110;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 26
    if (cycle == 25) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0100;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 27
    if (cycle == 26) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b1000;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 28
    if (cycle == 27) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0000;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 29
    if (cycle == 28) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0000;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 30
    if (cycle == 29) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0100;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 31
    if (cycle == 30) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0011;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 32
    if (cycle == 31) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b1000;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 33
    if (cycle == 32) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0011;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00100000;
    end

    // state 34
    if (cycle == 33) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0001;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 35
    if (cycle == 34) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0001;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000100;
    end

    // state 36
    if (cycle == 35) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b1000;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 37
    if (cycle == 36) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0100;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
    end

    // state 38
    if (cycle == 37) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0000;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b00100000;
    end

    // state 39
    if (cycle == 38) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0000;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00010000;
    end

    // state 40
    if (cycle == 39) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0001;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b00011100;
    end

    // state 41
    if (cycle == 40) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0001;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000100;
    end

    // state 42
    if (cycle == 41) begin
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 4'b0100;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b10000000;
    end

    // state 43
    if (cycle == 42) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0100;
      PI_wr_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00101000;
    end

    // state 44
    if (cycle == 43) begin
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 4'b0001;
      PI_wr_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
    end

    genclock <= cycle < 44;
    cycle <= cycle + 1;
  end
endmodule
