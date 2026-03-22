`default_nettype none

module halfadder (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

    // TODO: Implement half adder using assign statements
    // sum  = a XOR b
    // cout = a AND b
    assign sum = a ^ b;
    assign cout = a & b;

endmodule
