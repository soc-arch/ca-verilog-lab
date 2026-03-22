`default_nettype none

module param_adder #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             cin,
    output wire [WIDTH-1:0] sum,
    output wire             cout
);

    // TODO: Implement parameterized adder using assign
    // Hint: Use concatenation on the left-hand side
    //       {cout, sum} = a + b + cin;

endmodule
