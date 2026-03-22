`default_nettype none

module reg_file (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] raddr1,
    input  wire [1:0] raddr2,
    input  wire [1:0] waddr,
    input  wire [7:0] wdata,
    input  wire       we,
    output reg  [7:0] rdata1,
    output reg  [7:0] rdata2
);

    // TODO: Implement 4-entry x 8-bit register file
    //
    // Storage: reg [7:0] regs [0:3];
    //
    // Write port (sequential):
    //   On posedge clk, if we=1, write wdata to regs[waddr]
    //   On rst_n=0, clear all registers to 0
    //
    // Read ports (combinational):
    //   rdata1 = regs[raddr1]
    //   rdata2 = regs[raddr2]
    //
    // Hint: Use always @(*) for reads, always @(posedge clk ...) for writes
    //       Use integer i; for reset loop

endmodule
