`default_nettype none

module reg_file (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [1:0] raddr1,
    input  logic [1:0] raddr2,
    input  logic [1:0] waddr,
    input  logic [7:0] wdata,
    input  logic       we,
    output logic [7:0] rdata1,
    output logic [7:0] rdata2
);

    // TODO: Implement 4-entry x 8-bit register file
    //
    // Storage: logic [7:0] regs [0:3];
    //
    // Write port: always_ff
    // Read ports: always_comb

endmodule
