`default_nettype none

module decoder2to4 (
    input  wire [1:0] in,
    input  wire       en,
    output reg  [3:0] out
);

    // TODO: Implement 2-to-4 decoder with enable
    // When en=1: assert one bit of out based on in
    //   in=00 → out=4'b0001
    //   in=01 → out=4'b0010
    //   in=10 → out=4'b0100
    //   in=11 → out=4'b1000
    // When en=0: out=4'b0000

endmodule
