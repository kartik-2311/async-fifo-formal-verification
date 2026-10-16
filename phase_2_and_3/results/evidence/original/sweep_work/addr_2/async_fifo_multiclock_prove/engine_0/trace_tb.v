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
  reg [0:0] PI_wr_en;
  reg [0:0] PI_wr_rst_n;
  reg [0:0] PI_rd_rst_n;
  reg [0:0] PI_rd_en;
  reg [0:0] PI_rd_clk;
  reg [0:0] PI_wr_clk;
  async_fifo UUT (
    .wr_data(PI_wr_data),
    .wr_en(PI_wr_en),
    .wr_rst_n(PI_wr_rst_n),
    .rd_rst_n(PI_rd_rst_n),
    .rd_en(PI_rd_en),
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
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$104y#sampled$184  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$108#sampled$422  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$111y#sampled$414  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$115y#sampled$428  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$117#sampled$436  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$126y#sampled$134  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$79#sampled$478  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$82y#sampled$470  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$90y#sampled$484  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$92#sampled$492  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$$93y#sampled$498  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/rd_rst_n#sampled$144  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_formal .\rd_empty_prev#sampled$102  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_formal .\rd_gray_ptr_prev#sampled$112  = 3'b011;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_formal .\rd_gray_sync_prev#sampled$122  = 3'b001;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_formal .\rd_have_reset#sampled$132  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_formal .\rd_rst_n_prev#sampled$142  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_formal .\wr_full_prev#sampled$152  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_formal .\wr_gray_ptr_prev#sampled$162  = 3'b011;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_formal .\wr_gray_sync_prev#sampled$172  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_formal .\wr_have_reset#sampled$182  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_formal .\wr_rst_n_prev#sampled$192  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_rd_ptr .\rd_bin#sampled$202  = 3'b010;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_rd_ptr .\rd_bin_next#sampled$204  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_rd_ptr .\rd_empty#sampled$104  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_rd_ptr .\rd_empty#sampled$222  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_rd_ptr .\rd_empty#sampled$442  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_rd_ptr .\rd_empty_next#sampled$224  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_rd_ptr .\rd_gray_next#sampled$244  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_rd_ptr .\rd_gray_ptr#sampled$242  = 3'b110;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_rd_ptr .\rd_gray_ptr#sampled$264  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_sync_rd2wr .\meta_ff#sampled$262  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_sync_rd2wr .\meta_ff#sampled$284  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_sync_rd2wr .\sync_ff#sampled$124  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_sync_rd2wr .\sync_ff#sampled$282  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_sync_wr2rd .\meta_ff#sampled$302  = 3'b110;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_sync_wr2rd .\meta_ff#sampled$324  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_sync_wr2rd .\sync_ff#sampled$174  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_sync_wr2rd .\sync_ff#sampled$322  = 3'b111;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_wr_ptr .\wr_bin#sampled$342  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_wr_ptr .\wr_bin_next#sampled$344  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_wr_ptr .\wr_full#sampled$154  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_wr_ptr .\wr_full#sampled$362  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_wr_ptr .\wr_full_next#sampled$364  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_wr_ptr .\wr_gray_next#sampled$384  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_wr_ptr .\wr_gray_ptr#sampled$304  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/u_wr_ptr .\wr_gray_ptr#sampled$382  = 3'b000;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$/wr_rst_n#sampled$194  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:101:sample_data$1'1#sampled$236  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:206:execute$u_mem .\mem#0#en_q$94  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:209:execute$u_mem .\mem#0#addr_q$96  = 2'b00;
    // UUT.$auto$clk2fflogic.\cc:212:execute$u_mem .\mem#0#data_q$98  = 8'b00000000;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$293#sampled$294  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:75:sample_control$$auto$rtlil .\cc:3234:Not$333#sampled$334  = 1'b0;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/rd_clk#sampled$430  = 1'b1;
    // UUT.$auto$clk2fflogic.\cc:87:sample_control_edge$/wr_clk#sampled$386  = 1'b1;
    UUT.u_mem.mem[2'b10] = 8'b00000000;
    UUT.u_mem.mem[2'b11] = 8'b00000000;
    UUT.u_mem.mem[2'b00] = 8'b00000000;

    // state 0
    PI_wr_data = 8'b00000000;
    PI_wr_en = 1'b1;
    PI_wr_rst_n = 1'b0;
    PI_rd_rst_n = 1'b1;
    PI_rd_en = 1'b0;
    PI_rd_clk = 1'b1;
    PI_wr_clk = 1'b0;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_wr_data <= 8'b00001000;
      PI_wr_en <= 1'b0;
      PI_wr_rst_n <= 1'b1;
      PI_rd_rst_n <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 2
    if (cycle == 1) begin
      PI_wr_data <= 8'b00000010;
      PI_wr_en <= 1'b0;
      PI_wr_rst_n <= 1'b1;
      PI_rd_rst_n <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 3
    if (cycle == 2) begin
      PI_wr_data <= 8'b00100100;
      PI_wr_en <= 1'b1;
      PI_wr_rst_n <= 1'b1;
      PI_rd_rst_n <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 4
    if (cycle == 3) begin
      PI_wr_data <= 8'b00000000;
      PI_wr_en <= 1'b0;
      PI_wr_rst_n <= 1'b1;
      PI_rd_rst_n <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b0;
    end

    // state 5
    if (cycle == 4) begin
      PI_wr_data <= 8'b11101011;
      PI_wr_en <= 1'b0;
      PI_wr_rst_n <= 1'b1;
      PI_rd_rst_n <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    // state 6
    if (cycle == 5) begin
      PI_wr_data <= 8'b00100000;
      PI_wr_en <= 1'b1;
      PI_wr_rst_n <= 1'b1;
      PI_rd_rst_n <= 1'b1;
      PI_rd_en <= 1'b0;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 7
    if (cycle == 6) begin
      PI_wr_data <= 8'b00010000;
      PI_wr_en <= 1'b0;
      PI_wr_rst_n <= 1'b0;
      PI_rd_rst_n <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_rd_clk <= 1'b1;
      PI_wr_clk <= 1'b1;
    end

    // state 8
    if (cycle == 7) begin
      PI_wr_data <= 8'b11000011;
      PI_wr_en <= 1'b1;
      PI_wr_rst_n <= 1'b1;
      PI_rd_rst_n <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
    end

    // state 9
    if (cycle == 8) begin
      PI_wr_data <= 8'b00000000;
      PI_wr_en <= 1'b0;
      PI_wr_rst_n <= 1'b1;
      PI_rd_rst_n <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b1;
    end

    genclock <= cycle < 9;
    cycle <= cycle + 1;
  end
endmodule
