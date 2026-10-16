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
  reg [0:0] PI_wr_en;
  reg [7:0] PI_wr_data;
  reg [0:0] PI_wr_clk;
  reg [2:0] PI_tag_seq_in;
  async_fifo_integrity_top UUT (
    .rd_clk(PI_rd_clk),
    .rd_en(PI_rd_en),
    .wr_en(PI_wr_en),
    .wr_data(PI_wr_data),
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$114#sampled$502  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$115y#sampled$438  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$120y#sampled$452  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$123y#sampled$466  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$125#sampled$474  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$126y#sampled$480  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$143y#sampled$494  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$148y#sampled$508  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$153#sampled$530  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$154y#sampled$536  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$159#sampled$544  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$162y#sampled$564  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$110_Y#sampled$368  = 8'b00000001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$114_Y#sampled$408  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$118_Y#sampled$418  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$22_Y#sampled$378  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$26_Y#sampled$348  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$72_Y#sampled$388  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$146  = 3'b110;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$148  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$166  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$168  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$188  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$186  = 3'b011;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$208  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$206  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$228  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$226  = 3'b110;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$246  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$268  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$266  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$286  = 3'b101;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$288  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$306  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$308  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$328  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$248  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$326  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$346  = 3'b010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$356  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$366  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$376  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$386  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$396  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$406  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$550  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$416  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$398  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:206:execute$dut .u_mem.\mem#0#en_q$138  = 8'b01000101;
    // UUT.$auto$clk2fflogic.\cc:209:execute$dut .u_mem.\mem#0#addr_q$140  = 2'b00;
    // UUT.$auto$clk2fflogic.\cc:212:execute$dut .u_mem.\mem#0#data_q$142  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$337#sampled$338  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$552  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$468  = 1'b0;
    UUT.dut.u_mem.mem[2'b00] = 8'b00000000;
    UUT.dut.u_mem.mem[2'b01] = 8'b00000000;
    UUT.dut.u_mem.mem[2'b10] = 8'b00000000;
    UUT.dut.u_mem.mem[2'b11] = 8'b00000000;

    // state 0
    PI_rd_clk = 1'b1;
    PI_rd_en = 1'b1;
    PI_wr_en = 1'b1;
    PI_wr_data = 8'b00000000;
    PI_wr_clk = 1'b1;
    PI_tag_seq_in = 3'b000;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b000;
    end

    // state 2
    if (cycle == 1) begin
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00010000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b000;
    end

    // state 3
    if (cycle == 2) begin
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b101;
    end

    // state 4
    if (cycle == 3) begin
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b101;
    end

    // state 5
    if (cycle == 4) begin
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b01000000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b010;
    end

    // state 6
    if (cycle == 5) begin
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b000;
    end

    // state 7
    if (cycle == 6) begin
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000100;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b000;
    end

    // state 8
    if (cycle == 7) begin
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b10001000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b000;
    end

    // state 9
    if (cycle == 8) begin
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_wr_data <= 8'b00000011;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b110;
    end

    // state 10
    if (cycle == 9) begin
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000010;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b100;
    end

    // state 11
    if (cycle == 10) begin
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b01000000;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b101;
    end

    // state 12
    if (cycle == 11) begin
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b10000100;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b011;
    end

    // state 13
    if (cycle == 12) begin
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00100000;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b010;
    end

    // state 14
    if (cycle == 13) begin
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b101;
    end

    // state 15
    if (cycle == 14) begin
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b0;
      PI_tag_seq_in <= 3'b011;
    end

    // state 16
    if (cycle == 15) begin
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_tag_seq_in <= 3'b000;
    end

    genclock <= cycle < 16;
    cycle <= cycle + 1;
  end
endmodule
