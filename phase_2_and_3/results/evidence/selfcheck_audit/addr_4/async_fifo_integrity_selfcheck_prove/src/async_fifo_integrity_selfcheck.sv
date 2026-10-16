module async_fifo_integrity_selfcheck #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
) (
    input logic                  wr_clk,
    input logic                  rd_clk,
    input logic                  wr_en,
    input logic [DATA_WIDTH-1:0] wr_data,
    input logic                  rd_en,
    input logic [ADDR_WIDTH:0]   tag_seq_in
);

  localparam SEQ_W = ADDR_WIDTH + 1;

  logic rst_n;
  logic wr_seen;
  logic rd_seen;
  logic wr_rst_n_prev;
  logic rd_rst_n_prev;

  logic tag_set;
  logic [SEQ_W-1:0] tag_seq;
  logic [SEQ_W-1:0] tag_capture_value;

  logic wr_full;
  logic rd_empty;
  logic [DATA_WIDTH-1:0] rd_data;
  logic wr_acc;
  logic rd_acc;

  logic [SEQ_W-1:0] wr_cnt;
  logic [SEQ_W-1:0] rd_cnt;
  logic tag_written;
  logic tag_read;
  logic [DATA_WIDTH-1:0] tag_data;

  logic wr_first_armed;
  logic rd_after_first_wr;
  logic rd_first_armed;
  logic wr_after_first_rd;

  initial begin
    wr_seen = 1'b0;
    rd_seen = 1'b0;
    wr_rst_n_prev = 1'b0;
    rd_rst_n_prev = 1'b0;
    tag_set = 1'b0;
    wr_first_armed = 1'b0;
    rd_after_first_wr = 1'b0;
    rd_first_armed = 1'b0;
    wr_after_first_rd = 1'b0;
  end

  assign rst_n = wr_seen & rd_seen;
  assign wr_acc = wr_en & ~wr_full;
  assign rd_acc = rd_en & ~rd_empty;

  async_fifo #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
  ) dut (
      .wr_clk(wr_clk),
      .wr_rst_n(rst_n),
      .wr_en(wr_en),
      .wr_data(wr_data),
      .wr_full(wr_full),
      .rd_clk(rd_clk),
      .rd_rst_n(rst_n),
      .rd_en(rd_en),
      .rd_data(rd_data),
      .rd_empty(rd_empty)
  );

  always_ff @(posedge wr_clk) begin
    wr_seen <= 1'b1;

    if (wr_rst_n_prev) begin
      assert (wr_seen);
      assert (rd_seen);
      assert (rst_n);
    end
    wr_rst_n_prev <= rst_n;
    cover (wr_rst_n_prev);

    if (!tag_set) begin
      tag_seq <= tag_seq_in;
      tag_capture_value <= tag_seq_in;
      tag_set <= 1'b1;
    end

    if (!wr_first_armed && !rd_clk)
      wr_first_armed <= 1'b1;
    else if (wr_first_armed && !rd_after_first_wr && !rd_clk)
      cover (1'b1);
    if (rd_first_armed)
      wr_after_first_rd <= 1'b1;

    if (!rst_n) begin
      wr_cnt      <= '0;
      tag_written <= 1'b0;
      tag_data    <= '0;
    end else if (wr_acc) begin
      if (!tag_written && wr_cnt == tag_seq) begin
        tag_written <= 1'b1;
        tag_data    <= wr_data;
      end
      wr_cnt <= wr_cnt + 1'b1;
    end
  end

  always_ff @(posedge rd_clk) begin
    rd_seen <= 1'b1;

    if (rd_rst_n_prev) begin
      assert (wr_seen);
      assert (rd_seen);
      assert (rst_n);
    end
    rd_rst_n_prev <= rst_n;
    cover (rd_rst_n_prev);

    if (!rd_first_armed && !wr_clk)
      rd_first_armed <= 1'b1;
    else if (rd_first_armed && !wr_after_first_rd && !wr_clk)
      cover (1'b1);

    if (wr_first_armed)
      rd_after_first_wr <= 1'b1;

    if (!rst_n) begin
      rd_cnt   <= '0;
      tag_read <= 1'b0;
    end else if (rd_acc) begin
      if (!tag_read && rd_cnt == tag_seq) begin
        if (tag_seq == {SEQ_W{1'b1}} && tag_written &&
            rd_data == tag_data)
          cover (1'b1);
        tag_read <= 1'b1;
      end
      rd_cnt <= rd_cnt + 1'b1;
    end
  end

  always_comb begin
    assert (!wr_rst_n_prev || (wr_seen && rd_seen));
    assert (!rd_rst_n_prev || (wr_seen && rd_seen));

    if (tag_set)
      assert (tag_seq == tag_capture_value);
    cover (tag_set);
  end

endmodule
