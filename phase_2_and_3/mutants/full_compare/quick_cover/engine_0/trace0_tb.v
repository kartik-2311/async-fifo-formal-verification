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
  reg [2:0] PI_tag_seq_in;
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$122#sampled$431  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$123y#sampled$437  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$131#sampled$501  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$139y#sampled$507  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$104_Y#sampled$353  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$108_Y#sampled$393  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$112_Y#sampled$403  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$28_Y#sampled$363  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$32_Y#sampled$333  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$procmux$3_Y#sampled$373  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin#sampled$131  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_bin_next#sampled$133  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty#sampled$151  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_empty_next#sampled$153  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_next#sampled$173  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$171  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_rd_ptr.\rd_gray_ptr#sampled$193  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$191  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\meta_ff#sampled$213  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_rd2wr.\sync_ff#sampled$211  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$231  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\meta_ff#sampled$253  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_sync_wr2rd.\sync_ff#sampled$251  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin#sampled$271  = 3'b010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_bin_next#sampled$273  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full#sampled$291  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_full_next#sampled$293  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_next#sampled$313  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$233  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/dut .u_wr_ptr.\wr_gray_ptr#sampled$311  = 3'b011;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_cnt#sampled$331  = 3'b010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_seen#sampled$341  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_data#sampled$351  = 8'b00100000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_read#sampled$361  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_seq#sampled$371  = 3'b010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_set#sampled$381  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$391  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/tag_written#sampled$493  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_cnt#sampled$401  = 3'b010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$383  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$302#sampled$303  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$365  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$395  = 1'b1;

    // state 0
    PI_rd_clk = 1'b1;
    PI_wr_data = 8'b00000000;
    PI_rd_en = 1'b1;
    PI_tag_seq_in = 3'b000;
    PI_wr_en = 1'b0;
    PI_wr_clk = 1'b0;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 3'b100;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 2
    if (cycle == 1) begin
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b10000000;
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 3'b100;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 3
    if (cycle == 2) begin
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 4
    if (cycle == 3) begin
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 5
    if (cycle == 4) begin
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_en <= 1'b0;
      PI_tag_seq_in <= 3'b100;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 6
    if (cycle == 5) begin
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 7
    if (cycle == 6) begin
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 8
    if (cycle == 7) begin
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 9
    if (cycle == 8) begin
      PI_rd_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 3'b100;
      PI_wr_en <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 10
    if (cycle == 9) begin
      PI_rd_clk <= 1'b1;
      PI_wr_data <= 8'b00000000;
      PI_rd_en <= 1'b1;
      PI_tag_seq_in <= 3'b001;
      PI_wr_en <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    genclock <= cycle < 10;
    cycle <= cycle + 1;
  end
endmodule
