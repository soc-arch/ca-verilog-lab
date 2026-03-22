`default_nettype none

module seven_seg (
    input  wire [3:0] bcd,
    output reg  [6:0] seg
);

    // TODO: Implement 7-segment decoder using always @(*) with case
    // seg[6:0] = {g, f, e, d, c, b, a}, active-high
    //
    //   aaa
    //  f   b
    //   ggg
    //  e   c
    //   ddd
    //
    // Example: digit 0 lights up a,b,c,d,e,f → seg = 7'b0111111
    // Invalid BCD (10-15) → seg = 7'b0000000 (blank)

endmodule
