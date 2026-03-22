`default_nettype none

module mux2to1_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       sel,
    output wire [7:0] y
);

    // TODO: Implement 2:1 MUX
    // sel=0 → y=a, sel=1 → y=b

endmodule
