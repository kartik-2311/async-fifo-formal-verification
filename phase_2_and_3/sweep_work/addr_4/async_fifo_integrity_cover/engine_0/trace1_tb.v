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
  reg [4:0] PI_tag_seq_in;
  reg [0:0] PI_wr_en;
  reg [0:0] PI_rd_en;
  reg [7:0] PI_wr_data;
  reg [0:0] PI_rd_clk;
  reg [0:0] PI_wr_clk;
  async_fifo_integrity_top UUT (
    .tag_seq_in(PI_tag_seq_in),
    .wr_en(PI_wr_en),
    .rd_en(PI_rd_en),
    .wr_data(PI_wr_data),
    .rd_clk(PI_rd_clk),
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$177#sampled$548  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$186y#sampled$554  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$194#sampled$618  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$202y#sampled$624  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$104_Y#sampled$390  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$108_Y#sampled$430  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$112_Y#sampled$440  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$134_Y#sampled$410  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$138_Y#sampled$370  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$142_Y#sampled$450  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$22_Y#sampled$400  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$26_Y#sampled$360  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$158  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$160  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$178  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$180  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$200  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$198  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$220  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$218  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$240  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$238  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$258  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$280  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$278  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$298  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$300  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$318  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$320  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$340  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$260  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$338  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$358  = 5'b00001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$368  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$378  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$388  = 8'b00000001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$398  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$408  = 5'b10000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$418  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$428  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$610  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$438  = 5'b00100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$448  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$192  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$269#sampled$270  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$362  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$342  = 1'b1;

    // state 0
    PI_tag_seq_in = 5'b01000;
    PI_wr_en = 1'b0;
    PI_rd_en = 1'b1;
    PI_wr_data = 8'b00000000;
    PI_rd_clk = 1'b1;
    PI_wr_clk = 1'b0;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_tag_seq_in <= 5'b00010;
      PI_wr_en <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 2
    if (cycle == 1) begin
      PI_tag_seq_in <= 5'b11000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000100;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 3
    if (cycle == 2) begin
      PI_tag_seq_in <= 5'b00001;
      PI_wr_en <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b01000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 4
    if (cycle == 3) begin
      PI_tag_seq_in <= 5'b00100;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 5
    if (cycle == 4) begin
      PI_tag_seq_in <= 5'b10001;
      PI_wr_en <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 6
    if (cycle == 5) begin
      PI_tag_seq_in <= 5'b00001;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000001;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 7
    if (cycle == 6) begin
      PI_tag_seq_in <= 5'b00001;
      PI_wr_en <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 8
    if (cycle == 7) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 9
    if (cycle == 8) begin
      PI_tag_seq_in <= 5'b00100;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b01000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 10
    if (cycle == 9) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b10000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 11
    if (cycle == 10) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000010;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 12
    if (cycle == 11) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 13
    if (cycle == 12) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 14
    if (cycle == 13) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00100000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 15
    if (cycle == 14) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00010000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 16
    if (cycle == 15) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 17
    if (cycle == 16) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00001000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 18
    if (cycle == 17) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 19
    if (cycle == 18) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 20
    if (cycle == 19) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 21
    if (cycle == 20) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 22
    if (cycle == 21) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 23
    if (cycle == 22) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 24
    if (cycle == 23) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 25
    if (cycle == 24) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 26
    if (cycle == 25) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 27
    if (cycle == 26) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 28
    if (cycle == 27) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 29
    if (cycle == 28) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 30
    if (cycle == 29) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 31
    if (cycle == 30) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 32
    if (cycle == 31) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 33
    if (cycle == 32) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 34
    if (cycle == 33) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 35
    if (cycle == 34) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 36
    if (cycle == 35) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 37
    if (cycle == 36) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 38
    if (cycle == 37) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 39
    if (cycle == 38) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 40
    if (cycle == 39) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 41
    if (cycle == 40) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 42
    if (cycle == 41) begin
      PI_tag_seq_in <= 5'b00000;
      PI_wr_en <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    genclock <= cycle < 42;
    cycle <= cycle + 1;
  end
endmodule
