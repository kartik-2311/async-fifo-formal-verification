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
  reg [0:0] PI_wr_clk;
  reg [7:0] PI_wr_data;
  reg [0:0] PI_rd_rst_n;
  reg [0:0] PI_rd_en;
  reg [0:0] PI_wr_en;
  reg [0:0] PI_wr_rst_n;
  async_fifo UUT (
    .rd_clk(PI_rd_clk),
    .wr_clk(PI_wr_clk),
    .wr_data(PI_wr_data),
    .rd_rst_n(PI_rd_rst_n),
    .rd_en(PI_rd_en),
    .wr_en(PI_wr_en),
    .wr_rst_n(PI_wr_rst_n)
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
    // UUT.$auto$async2sync.\cc:107:execute$148  = 1'b0;
    // UUT.$auto$async2sync.\cc:107:execute$178  = 1'b0;
    // UUT.$auto$async2sync.\cc:116:execute$152  = 1'b1;
    // UUT.$auto$async2sync.\cc:116:execute$176  = 1'b1;
    // UUT.$auto$async2sync.\cc:116:execute$182  = 1'b1;
    UUT._witness_.anyinit_driver_u_rd_ptr_rd_bin = 5'b01111;
    UUT._witness_.anyinit_driver_u_rd_ptr_rd_empty = 1'b0;
    UUT._witness_.anyinit_driver_u_rd_ptr_rd_gray_ptr = 5'b01000;
    UUT._witness_.anyinit_driver_u_sync_rd2wr_meta_ff = 5'b11000;
    UUT._witness_.anyinit_driver_u_sync_rd2wr_sync_ff = 5'b11010;
    UUT._witness_.anyinit_driver_u_sync_wr2rd_meta_ff = 5'b00001;
    UUT._witness_.anyinit_driver_u_sync_wr2rd_sync_ff = 5'b00001;
    UUT._witness_.anyinit_driver_u_wr_ptr_wr_bin = 5'b00010;
    UUT._witness_.anyinit_driver_u_wr_ptr_wr_full = 1'b1;
    UUT._witness_.anyinit_driver_u_wr_ptr_wr_gray_ptr = 5'b00010;
    UUT.u_formal.rd_empty_prev = 1'b0;
    UUT.u_formal.rd_have_reset = 1'b0;
    UUT.u_formal.wr_full_prev = 1'b0;
    UUT.u_formal.wr_have_reset = 1'b0;
    UUT.u_mem.mem[4'b1111] = 8'b00000000;
    UUT.u_mem.mem[4'b0000] = 8'b00000100;

    // state 0
    PI_rd_clk = 1'b0;
    PI_wr_clk = 1'b0;
    PI_wr_data = 8'b00000000;
    PI_rd_rst_n = 1'b1;
    PI_rd_en = 1'b1;
    PI_wr_en = 1'b0;
    PI_wr_rst_n = 1'b0;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_rst_n <= 1'b1;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_wr_rst_n <= 1'b1;
    end

    // state 2
    if (cycle == 1) begin
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_rst_n <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_wr_rst_n <= 1'b1;
    end

    // state 3
    if (cycle == 2) begin
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_rst_n <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_wr_rst_n <= 1'b1;
    end

    // state 4
    if (cycle == 3) begin
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_rst_n <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_wr_rst_n <= 1'b1;
    end

    // state 5
    if (cycle == 4) begin
      PI_rd_clk <= 1'b0;
      PI_wr_clk <= 1'b0;
      PI_wr_data <= 8'b00000000;
      PI_rd_rst_n <= 1'b0;
      PI_rd_en <= 1'b1;
      PI_wr_en <= 1'b0;
      PI_wr_rst_n <= 1'b1;
    end

    genclock <= cycle < 5;
    cycle <= cycle + 1;
  end
endmodule
