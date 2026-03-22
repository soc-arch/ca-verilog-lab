`default_nettype none

module alu (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] op,
    output reg  [7:0] y,
    output wire       zero
);

    // TODO: Implement ALU using always @(*) with case for y
    // op=000: y = a + b
    // op=001: y = a - b
    // op=010: y = a & b
    // op=011: y = a | b
    // op=100: y = a ^ b
    // op=101: y = ~a
    // op=110: y = a << 1
    // op=111: y = a >> 1

    // TODO: Implement zero flag using assign
    // zero = 1 when y == 0

endmodule
