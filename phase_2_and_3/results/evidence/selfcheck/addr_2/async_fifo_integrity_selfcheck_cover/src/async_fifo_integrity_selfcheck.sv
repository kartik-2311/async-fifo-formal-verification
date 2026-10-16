module async_fifo_integrity_selfcheck #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 2
) (
    input logic                  wr_clk,
    input logic                  rd_clk,
    input logic                  wr_en,
    input logic [DATA_WIDTH-1:0] wr_data,
    input logic                  rd_en,
    input logic [ADDR_WIDTH:0]   tag_seq_in
);

  localparam SEQ_W = ADDR_WIDTH + 1;

  async_fifo_integrity_top #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) checked (
      .wr_clk(wr_clk),
      .rd_clk(rd_clk),
      .wr_en(wr_en),
      .wr_data(wr_data),
      .rd_en(rd_en),
      .tag_seq_in(tag_seq_in)
  );

  logic                  tag_capture_valid;
  logic [SEQ_W-1:0]      tag_capture_value;
  logic                  wr_reset_high_seen;
  logic                  rd_reset_high_seen;
  logic                  wr_first_armed;
  logic                  rd_after_first_wr;
  logic                  rd_first_armed;
  logic                  wr_after_first_rd;

  initial begin
    tag_capture_valid = 1'b0;
    wr_reset_high_seen = 1'b0;
    rd_reset_high_seen = 1'b0;
    wr_first_armed = 1'b0;
    rd_after_first_wr = 1'b0;
    rd_first_armed = 1'b0;
    wr_after_first_rd = 1'b0;
  end

  always_ff @(posedge wr_clk) begin
    if (!checked.tag_set && !tag_capture_valid) begin
      tag_capture_value <= tag_seq_in;
      tag_capture_valid <= 1'b1;
    end

    if (!wr_first_armed && !rd_clk) begin
      wr_first_armed <= 1'b1;
    end else if (wr_first_armed && !rd_after_first_wr && !rd_clk) begin
      cover (1'b1);
    end
    if (rd_first_armed)
      wr_after_first_rd <= 1'b1;

    if (wr_reset_high_seen)
      assert (checked.rst_n);
    if (checked.rst_n)
      wr_reset_high_seen <= 1'b1;
    cover (wr_reset_high_seen);
  end

  always_ff @(posedge rd_clk) begin
    if (!rd_first_armed && !wr_clk) begin
      rd_first_armed <= 1'b1;
    end else if (rd_first_armed && !wr_after_first_rd && !wr_clk) begin
      cover (1'b1);
    end
    if (wr_first_armed)
      rd_after_first_wr <= 1'b1;

    if (rd_reset_high_seen)
      assert (checked.rst_n);
    if (checked.rst_n)
      rd_reset_high_seen <= 1'b1;
    cover (rd_reset_high_seen);
  end

  always_ff @(posedge rd_clk) begin
    if (checked.tag_set && checked.tag_written && !checked.tag_read &&
        checked.rd_acc && checked.rd_cnt == checked.tag_seq &&
        checked.tag_seq == {SEQ_W{1'b1}})
      cover (1'b1);
  end
  always_comb begin
    if (tag_capture_valid)
      assert (checked.tag_seq == tag_capture_value);
    cover (tag_capture_valid);
  end

endmodule
