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
  reg [2:0] PI_tag_seq_in;
  reg [0:0] PI_rd_clk;
  reg [0:0] PI_rd_en;
  reg [7:0] PI_wr_data;
  reg [0:0] PI_wr_en;
  reg [0:0] PI_wr_clk;
  async_fifo_integrity_top UUT (
    .tag_seq_in(PI_tag_seq_in),
    .rd_clk(PI_rd_clk),
    .rd_en(PI_rd_en),
    .wr_data(PI_wr_data),
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$124#sampled$488  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$125y#sampled$466  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$130y#sampled$480  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$133y#sampled$494  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$135#sampled$502  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$136y#sampled$508  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$154#sampled$530  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$155y#sampled$522  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$160y#sampled$536  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$165#sampled$558  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$166y#sampled$564  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$171#sampled$586  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$174y#sampled$592  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$4#sampled$628  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$9#sampled$642  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$130_Y#sampled$406  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$134_Y#sampled$366  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$138_Y#sampled$446  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$35_Y#sampled$386  = 8'b01000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$39_Y#sampled$426  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$43_Y#sampled$436  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$80_Y#sampled$396  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$84_Y#sampled$356  = 3'b111;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$154  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$156  = 3'b111;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$174  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$176  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$196  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$194  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$216  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$214  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$236  = 3'b110;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$234  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$254  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$276  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$274  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$294  = 3'b100;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$296  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$314  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$316  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$336  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$256  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$334  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$354  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$364  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_reset_done#sampled$648  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$374  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$384  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$394  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$404  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$414  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$424  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$578  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$434  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$444  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_reset_done#sampled$634  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$416  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:206:execute$dut .u_mem.\mem#0#en_q$146  = 8'b11101000;
    // UUT.$auto$clk2fflogic.\cc:209:execute$dut .u_mem.\mem#0#addr_q$148  = 2'b00;
    // UUT.$auto$clk2fflogic.\cc:212:execute$dut .u_mem.\mem#0#data_q$150  = 8'b10001000;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$345#sampled$346  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$552  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$496  = 1'b0;
    UUT.dut.u_mem.mem[2'b11] = 8'b00000000;
    UUT.dut.u_mem.mem[2'b00] = 8'b10001010;
    UUT.dut.u_mem.mem[2'b01] = 8'b11111111;

    // state 0
    PI_tag_seq_in = 3'b001;
    PI_rd_clk = 1'b1;
    PI_rd_en = 1'b1;
    PI_wr_data = 8'b10001000;
    PI_wr_en = 1'b0;
    PI_wr_clk = 1'b1;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_tag_seq_in <= 3'b001;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b01000000;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 2
    if (cycle == 1) begin
      PI_tag_seq_in <= 3'b011;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b11111101;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 3
    if (cycle == 2) begin
      PI_tag_seq_in <= 3'b100;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b11011000;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 4
    if (cycle == 3) begin
      PI_tag_seq_in <= 3'b011;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b01000000;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 5
    if (cycle == 4) begin
      PI_tag_seq_in <= 3'b001;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000010;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 6
    if (cycle == 5) begin
      PI_tag_seq_in <= 3'b011;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b11111111;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 7
    if (cycle == 6) begin
      PI_tag_seq_in <= 3'b001;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 8
    if (cycle == 7) begin
      PI_tag_seq_in <= 3'b100;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00100000;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 9
    if (cycle == 8) begin
      PI_tag_seq_in <= 3'b011;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 10
    if (cycle == 9) begin
      PI_tag_seq_in <= 3'b100;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 11
    if (cycle == 10) begin
      PI_tag_seq_in <= 3'b010;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b00001000;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 12
    if (cycle == 11) begin
      PI_tag_seq_in <= 3'b001;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 13
    if (cycle == 12) begin
      PI_tag_seq_in <= 3'b100;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b01000000;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 14
    if (cycle == 13) begin
      PI_tag_seq_in <= 3'b100;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b00010000;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 15
    if (cycle == 14) begin
      PI_tag_seq_in <= 3'b100;
      PI_rd_clk <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_data <= 8'b01000000;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 16
    if (cycle == 15) begin
      PI_tag_seq_in <= 3'b100;
      PI_rd_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_wr_data <= 8'b01000000;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    genclock <= cycle < 16;
    cycle <= cycle + 1;
  end
endmodule
