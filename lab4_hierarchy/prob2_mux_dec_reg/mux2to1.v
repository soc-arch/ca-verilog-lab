`default_nettype none

module mux2to1 (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       sel,
    output wire [7:0] y
);

    // TODO: Implement 2:1 MUX using assign
    // sel=0 → y=a, sel=1 → y=b

endmodule
