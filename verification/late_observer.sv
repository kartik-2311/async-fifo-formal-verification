// Additive safety observer: select any accepted write, arbitrarily late.
// The original finite-tag checker remains instantiated with every property.
// No fairness is imposed: eventual delivery is not a liveness claim.
module late_observer_top #(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4
)(
  input logic wr_clk, rd_clk, wr_en, rd_en,
  input logic [DATA_WIDTH-1:0] wr_data,
  input logic [ADDR_WIDTH:0] tag_seq_in,
  input logic choose_in
);
  localparam int DEPTH = 1 << ADDR_WIDTH;
  async_fifo_integrity_top #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) legacy (
    .wr_clk(wr_clk), .rd_clk(rd_clk), .wr_en(wr_en), .rd_en(rd_en),
    .wr_data(wr_data), .tag_seq_in(tag_seq_in)
  );

  // Observer state is independent of the original finite tag selection.
  logic selected = 1'b0;
  logic consumed = 1'b0;
  logic [ADDR_WIDTH:0] chosen_ptr;
  logic [DATA_WIDTH-1:0] chosen_data;
  logic [1:0] write_wraps = 0;
  logic selected_late = 0;
  wire [ADDR_WIDTH:0] ahead = chosen_ptr - legacy.rd_cnt;

  always @(posedge wr_clk) begin
    if (legacy.rst_n && legacy.wr_reset_done) begin
      if (legacy.wr_acc && (&legacy.wr_cnt) && write_wraps != 3)
        write_wraps <= write_wraps + 1'b1;
      if (choose_in && legacy.wr_acc && !selected) begin
        selected <= 1'b1;
        chosen_ptr <= legacy.wr_cnt;
        chosen_data <= wr_data;
        selected_late <= write_wraps != 0;
      end
      if (selected && !consumed && legacy.wr_acc) begin
        // No later write can overwrite the selected item while pending.
        assert (legacy.wr_cnt[ADDR_WIDTH-1:0] != chosen_ptr[ADDR_WIDTH-1:0]);
      end
    end
  end

  always_comb begin
    if (legacy.rst_n && selected && !consumed) begin
      assert (ahead < DEPTH);
      assert (legacy.dut.u_mem.mem[chosen_ptr[ADDR_WIDTH-1:0]] == chosen_data);
    end
  end

  always @(posedge rd_clk) begin
    if (legacy.rst_n && legacy.rd_reset_done && selected && !consumed && legacy.rd_acc) begin
      if (legacy.rd_cnt == chosen_ptr) begin
        assert (legacy.rd_data == chosen_data);
        consumed <= 1'b1;
      end
    end
    cover (selected && consumed);
    // At least one complete extended counter wrap: selection beyond two laps.
    cover (selected_late && consumed);
  end
endmodule
