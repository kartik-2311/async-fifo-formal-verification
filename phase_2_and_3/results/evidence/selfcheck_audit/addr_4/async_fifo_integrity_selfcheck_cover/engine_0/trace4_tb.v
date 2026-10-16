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
  reg [0:0] PI_rd_clk;
  reg [0:0] PI_wr_en;
  reg [7:0] PI_wr_data;
  reg [0:0] PI_wr_clk;
  reg [0:0] PI_rd_en;
  async_fifo_integrity_selfcheck UUT (
    .tag_seq_in(PI_tag_seq_in),
    .rd_clk(PI_rd_clk),
    .wr_en(PI_wr_en),
    .wr_data(PI_wr_data),
    .wr_clk(PI_wr_clk),
    .rd_en(PI_rd_en)
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$115#sampled$516  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$148#sampled$586  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$160#sampled$600  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$102_Y#sampled$458  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$106_Y#sampled$478  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$109_Y#sampled$398  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$112_Y#sampled$428  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$23_Y#sampled$418  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$27_Y#sampled$358  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$30_Y#sampled$348  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$34_Y#sampled$368  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$91_Y#sampled$408  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$95_Y#sampled$448  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$99_Y#sampled$468  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$146  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$148  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$166  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$168  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$188  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$186  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$208  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_rst_n#sampled$488  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$206  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$228  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$226  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$246  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$268  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$266  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$286  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$288  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$306  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$308  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$328  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$248  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$326  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_after_first_wr#sampled$346  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$356  = 5'b10000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_first_armed#sampled$366  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_rst_n_prev#sampled$376  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_rst_n_prev#sampled$578  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$386  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_capture_value#sampled$396  = 5'b10111;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$406  = 8'b00001000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$416  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$426  = 5'b11111;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$436  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$446  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_after_first_rd#sampled$456  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$466  = 5'b11110;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_first_armed#sampled$476  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_rst_n_prev#sampled$486  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_rst_n_prev#sampled$508  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$502  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:206:execute$dut .u_mem.\mem#0#en_q$138  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:209:execute$dut .u_mem.\mem#0#addr_q$140  = 4'b0000;
    // UUT.$auto$clk2fflogic.\cc:212:execute$dut .u_mem.\mem#0#data_q$142  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$337#sampled$338  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$420  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$510  = 1'b1;
    UUT.dut.u_mem.mem[4'b0000] = 8'b00000000;
    UUT.dut.u_mem.mem[4'b0001] = 8'b00000000;
    UUT.dut.u_mem.mem[4'b0010] = 8'b00000001;
    UUT.dut.u_mem.mem[4'b0011] = 8'b00100000;
    UUT.dut.u_mem.mem[4'b0100] = 8'b00000001;
    UUT.dut.u_mem.mem[4'b0101] = 8'b00000000;
    UUT.dut.u_mem.mem[4'b0110] = 8'b10000000;
    UUT.dut.u_mem.mem[4'b0111] = 8'b00000010;
    UUT.dut.u_mem.mem[4'b1000] = 8'b00000000;
    UUT.dut.u_mem.mem[4'b1001] = 8'b00000000;
    UUT.dut.u_mem.mem[4'b1010] = 8'b00100000;
    UUT.dut.u_mem.mem[4'b1011] = 8'b10000000;
    UUT.dut.u_mem.mem[4'b1100] = 8'b00010000;
    UUT.dut.u_mem.mem[4'b1101] = 8'b00001001;
    UUT.dut.u_mem.mem[4'b1110] = 8'b11111110;
    UUT.dut.u_mem.mem[4'b1111] = 8'b00000000;

    // state 0
    PI_tag_seq_in = 5'b11111;
    PI_rd_clk = 1'b0;
    PI_wr_en = 1'b0;
    PI_wr_data = 8'b00000000;
    PI_wr_clk = 1'b0;
    PI_rd_en = 1'b1;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 2
    if (cycle == 1) begin
      PI_tag_seq_in <= 5'b11111;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b01000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 3
    if (cycle == 2) begin
      PI_tag_seq_in <= 5'b10111;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 4
    if (cycle == 3) begin
      PI_tag_seq_in <= 5'b11101;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 5
    if (cycle == 4) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 6
    if (cycle == 5) begin
      PI_tag_seq_in <= 5'b01111;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b0;
    end

    // state 7
    if (cycle == 6) begin
      PI_tag_seq_in <= 5'b01111;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 8
    if (cycle == 7) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00100000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b0;
    end

    // state 9
    if (cycle == 8) begin
      PI_tag_seq_in <= 5'b10111;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 10
    if (cycle == 9) begin
      PI_tag_seq_in <= 5'b01111;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 11
    if (cycle == 10) begin
      PI_tag_seq_in <= 5'b11101;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b01000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 12
    if (cycle == 11) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 13
    if (cycle == 12) begin
      PI_tag_seq_in <= 5'b11101;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 14
    if (cycle == 13) begin
      PI_tag_seq_in <= 5'b10111;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b10000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b0;
    end

    // state 15
    if (cycle == 14) begin
      PI_tag_seq_in <= 5'b10111;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 16
    if (cycle == 15) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000010;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 17
    if (cycle == 16) begin
      PI_tag_seq_in <= 5'b11101;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 18
    if (cycle == 17) begin
      PI_tag_seq_in <= 5'b11011;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 19
    if (cycle == 18) begin
      PI_tag_seq_in <= 5'b01100;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 20
    if (cycle == 19) begin
      PI_tag_seq_in <= 5'b11101;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 21
    if (cycle == 20) begin
      PI_tag_seq_in <= 5'b11110;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00100011;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 22
    if (cycle == 21) begin
      PI_tag_seq_in <= 5'b10111;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00100000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 23
    if (cycle == 22) begin
      PI_tag_seq_in <= 5'b11110;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 24
    if (cycle == 23) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b10000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 25
    if (cycle == 24) begin
      PI_tag_seq_in <= 5'b01111;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 26
    if (cycle == 25) begin
      PI_tag_seq_in <= 5'b11101;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00010000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 27
    if (cycle == 26) begin
      PI_tag_seq_in <= 5'b11110;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00100000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 28
    if (cycle == 27) begin
      PI_tag_seq_in <= 5'b11011;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00001001;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 29
    if (cycle == 28) begin
      PI_tag_seq_in <= 5'b10111;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00100000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 30
    if (cycle == 29) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b11111110;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b0;
    end

    // state 31
    if (cycle == 30) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 32
    if (cycle == 31) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 33
    if (cycle == 32) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 34
    if (cycle == 33) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 35
    if (cycle == 34) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00001000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 36
    if (cycle == 35) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 37
    if (cycle == 36) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00001000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 38
    if (cycle == 37) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b10000010;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 39
    if (cycle == 38) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b10000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 40
    if (cycle == 39) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00100000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 41
    if (cycle == 40) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 42
    if (cycle == 41) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 43
    if (cycle == 42) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 44
    if (cycle == 43) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b10000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 45
    if (cycle == 44) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 46
    if (cycle == 45) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 47
    if (cycle == 46) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 48
    if (cycle == 47) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000010;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 49
    if (cycle == 48) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b01000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 50
    if (cycle == 49) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00001000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 51
    if (cycle == 50) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00001000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 52
    if (cycle == 51) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b10000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 53
    if (cycle == 52) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 54
    if (cycle == 53) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b10000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 55
    if (cycle == 54) begin
      PI_tag_seq_in <= 5'b11101;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 56
    if (cycle == 55) begin
      PI_tag_seq_in <= 5'b11111;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 57
    if (cycle == 56) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 58
    if (cycle == 57) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00010010;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b0;
    end

    // state 59
    if (cycle == 58) begin
      PI_tag_seq_in <= 5'b11111;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 60
    if (cycle == 59) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00001000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 61
    if (cycle == 60) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 62
    if (cycle == 61) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b10001000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b0;
    end

    // state 63
    if (cycle == 62) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 64
    if (cycle == 63) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 65
    if (cycle == 64) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 66
    if (cycle == 65) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 67
    if (cycle == 66) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 68
    if (cycle == 67) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 69
    if (cycle == 68) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b1;
    end

    // state 70
    if (cycle == 69) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00100000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b0;
    end

    // state 71
    if (cycle == 70) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b0;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00100000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    // state 72
    if (cycle == 71) begin
      PI_tag_seq_in <= 5'b00000;
      PI_rd_clk <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b1;
    end

    genclock <= cycle < 72;
    cycle <= cycle + 1;
  end
endmodule
