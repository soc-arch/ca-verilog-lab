`default_nettype none

module alu_acc (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] b,
    input  logic [2:0] op,
    input  logic       en,
    output logic [7:0] acc,
    output logic       zero
);

    // TODO: Implement ALU + Accumulator using SystemVerilog
    //
    // Step 1 — Combinational: ALU (use always_comb)
    //   logic [7:0] alu_result;
    //   always_comb begin ... end
    //
    // Step 2 — Sequential: Accumulator register (use always_ff)
    //   always_ff @(posedge clk or negedge rst_n) begin ... end
    //
    // Step 3 — Combinational: zero flag (use assign)

endmodule
