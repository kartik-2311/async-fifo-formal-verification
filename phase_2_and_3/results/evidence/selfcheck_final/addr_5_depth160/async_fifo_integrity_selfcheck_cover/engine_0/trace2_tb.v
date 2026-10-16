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
  reg [5:0] PI_tag_seq_in;
  reg [0:0] PI_wr_en;
  reg [7:0] PI_wr_data;
  reg [0:0] PI_wr_clk;
  reg [0:0] PI_rd_en;
  reg [0:0] PI_rd_clk;
  async_fifo_integrity_selfcheck UUT (
    .tag_seq_in(PI_tag_seq_in),
    .wr_en(PI_wr_en),
    .wr_data(PI_wr_data),
    .wr_clk(PI_wr_clk),
    .rd_en(PI_rd_en),
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$115#sampled$516  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$148#sampled$586  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$160#sampled$600  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$102_Y#sampled$458  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$106_Y#sampled$478  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$109_Y#sampled$398  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$112_Y#sampled$428  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$23_Y#sampled$418  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$27_Y#sampled$358  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$30_Y#sampled$348  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$34_Y#sampled$368  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$91_Y#sampled$408  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$95_Y#sampled$448  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$99_Y#sampled$468  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$146  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$148  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$166  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$168  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$188  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$186  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$208  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_rst_n#sampled$488  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$206  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$228  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$226  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$246  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$268  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$266  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$286  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$288  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$306  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$308  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$328  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$248  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$326  = 6'b000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_after_first_wr#sampled$346  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$356  = 6'b000001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_first_armed#sampled$366  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_rst_n_prev#sampled$376  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_rst_n_prev#sampled$578  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$386  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_capture_value#sampled$396  = 6'b010000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$406  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$416  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$426  = 6'b001001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$436  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$446  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_after_first_rd#sampled$456  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$466  = 6'b001001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_first_armed#sampled$476  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_rst_n_prev#sampled$486  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_rst_n_prev#sampled$508  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$502  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:206:execute$dut .u_mem.\mem#0#en_q$138  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:209:execute$dut .u_mem.\mem#0#addr_q$140  = 5'b00000;
    // UUT.$auto$clk2fflogic.\cc:212:execute$dut .u_mem.\mem#0#data_q$142  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$337#sampled$338  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$420  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$510  = 1'b1;
    UUT.dut.u_mem.mem[5'b00000] = 8'b00000000;

    // state 0
    PI_tag_seq_in = 6'b000000;
    PI_wr_en = 1'b1;
    PI_wr_data = 8'b00000000;
    PI_wr_clk = 1'b0;
    PI_rd_en = 1'b0;
    PI_rd_clk = 1'b0;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_tag_seq_in <= 6'b000000;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000010;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_rd_clk <= 1'b1;
    end

    // state 2
    if (cycle == 1) begin
      PI_tag_seq_in <= 6'b000000;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000001;
      PI_wr_clk <= 1'b0;
      PI_rd_en <= 1'b0;
      PI_rd_clk <= 1'b0;
    end

    // state 3
    if (cycle == 2) begin
      PI_tag_seq_in <= 6'b000000;
      PI_wr_en <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_wr_clk <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_rd_clk <= 1'b1;
    end

    genclock <= cycle < 3;
    cycle <= cycle + 1;
  end
endmodule
