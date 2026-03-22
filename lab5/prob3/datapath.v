`default_nettype none

module datapath (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [1:0] raddr1,
    input  logic [1:0] raddr2,
    input  logic [1:0] waddr,
    input  logic       we,
    input  logic [2:0] alu_op,
    input  logic [7:0] imm,
    input  logic       src_b_sel,
    output logic [7:0] alu_result,
    output logic       zero
);

    // TODO: Instantiate sub-modules using dot-name (.name) connections
    //
    // Internal signals (all logic, no wire/reg):
    //   logic [7:0] rdata1, rdata2;
    //   logic [7:0] alu_b;
    //
    // Use dot-name where signal and port names match:
    //   reg_file u_rf (
    //       .clk,              // dot-name
    //       .rst_n,            // dot-name
    //       .raddr1,           // dot-name
    //       .raddr2,           // dot-name
    //       .waddr,            // dot-name
    //       .wdata (alu_result), // named (different names)
    //       .we,               // dot-name
    //       .rdata1,           // dot-name
    //       .rdata2            // dot-name
    //   );

endmodule
