// counter.sv
// Minimal toy design to validate the Yosys + SymbiYosys + solver formal flow
// before applying formal methods to the real async FIFO.

module counter (
    input  logic       clk,
    input  logic        rst,
    output logic [1:0]  count
);

  always_ff @(posedge clk) begin
    if (rst)
      count <= 2'd0;
    else
      count <= count + 2'd1;
  end

  // --------------------------------------------------------------------
  // NOTE: these are IMMEDIATE assertions (plain statements inside a
  // clocked always block), not concurrent SVA (`assert property (@(...))`).
  // Plain Yosys (read_verilog -sv, no slang/Verific frontend) only
  // parses this simpler form. It's enough to validate the tool flow.
  // When we move to the real FIFO's temporal properties, we'll switch
  // to the slang frontend for full concurrent-SVA support.
  // --------------------------------------------------------------------
  always_ff @(posedge clk) begin
    // Safety: a 2-bit register can never hold a value above 3. Trivially
    // true by construction -- a passing proof here just confirms the
    // tool flow (parse -> prove -> pass/fail) works end to end.
    assert (count <= 2'd3);

    // Cover: prove count == 3 is actually reachable, so the assertion
    // above isn't vacuously true (e.g. because of a stuck reset).
    cover (count == 2'd3);
  end

endmodule