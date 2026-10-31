`timescale 1ns/1ps
// Hardware demonstration, not a replacement for the formal property suite.
module fifo_smoke(input wire wr_clk, rd_clk, wr_rst_n, rd_rst_n,
                  output reg passed=0, failed=0);
  reg [15:0] write_seq=0, read_seq=0;
  reg [2:0] write_phase=0;
  reg [7:0] read_phase=0;
  wire wr_full, rd_empty;
  wire wr_en = write_phase != 7;
  wire rd_en = read_phase[7];
  wire [7:0] wr_data = write_seq[7:0] ^ write_seq[15:8] ^ 8'ha5;
  wire [7:0] expected_data = read_seq[7:0] ^ read_seq[15:8] ^ 8'ha5;
  wire [7:0] rd_data;
  reg full_seen=0, empty_seen=0;
  (* ASYNC_REG="TRUE", SHREG_EXTRACT="NO" *) reg full_meta=0, full_sync=0;
  reg [21:0] watchdog=0;
  reg [7:0] sampled_data=0, sampled_expected=0;
  reg compare_valid=0;
  async_fifo #(.DATA_WIDTH(8),.ADDR_WIDTH(4)) u_fifo(
    .wr_clk(wr_clk), .wr_rst_n(wr_rst_n), .wr_en(wr_en), .wr_data(wr_data), .wr_full(wr_full),
    .rd_clk(rd_clk), .rd_rst_n(rd_rst_n), .rd_en(rd_en), .rd_data(rd_data), .rd_empty(rd_empty));
  always @(posedge wr_clk or negedge wr_rst_n) begin
    if(!wr_rst_n) begin write_seq<=0; write_phase<=0; full_seen<=0; end
    else begin
      write_phase<=write_phase+1'b1;
      if(wr_full) full_seen<=1;
      if(wr_en && !wr_full) write_seq<=write_seq+1'b1;
    end
  end
  always @(posedge rd_clk or negedge rd_rst_n) begin
    if(!rd_rst_n) begin
      read_seq<=0; read_phase<=0; passed<=0; failed<=0;
      empty_seen<=0; full_meta<=0; full_sync<=0; watchdog<=0;
      sampled_data<=0; sampled_expected<=0; compare_valid<=0;
    end else begin
      read_phase<=read_phase+1'b1;
      full_meta<=full_seen; full_sync<=full_meta;
      if(rd_empty) empty_seen<=1;
      // Separate the RAM capture path from local comparison/error logic.
      compare_valid<=rd_en && !rd_empty;
      if(compare_valid && sampled_data != sampled_expected) failed<=1;
      if(rd_en && !rd_empty) begin
        sampled_data<=rd_data;
        sampled_expected<=expected_data;
        read_seq<=read_seq+1'b1;
        watchdog<=0;
        if(read_seq>=1023 && full_sync && empty_seen) passed<=1;
      end else if(&watchdog) failed<=1;
      else watchdog<=watchdog+1'b1;
    end
  end
endmodule
