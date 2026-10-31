module clock_canary (
    input logic wr_clk,
    input logic rd_clk
);
    logic wr_tick;
    logic rd_tick;
    initial begin
        wr_tick = 1'b0;
        rd_tick = 1'b0;
    end
    always_ff @(posedge wr_clk) wr_tick <= ~wr_tick;
    always_ff @(posedge rd_clk) rd_tick <= ~rd_tick;
    always_comb assert (wr_tick == rd_tick);
endmodule
