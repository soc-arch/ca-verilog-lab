`default_nettype none

module barrel_shifter (
    input  wire [7:0] data,
    input  wire [2:0] shamt,
    output reg  [7:0] y
);

    // TODO: Implement left-rotate barrel shifter
    // shamt=0: y = data (no rotation)
    // shamt=1: y = {data[6:0], data[7]}
    // shamt=2: y = {data[5:0], data[7:6]}
    // ... etc
    //
    // Hint: Use case statement, or try:
    //   y = (shamt == 0) ? data : ...
    //   Or use concatenation trick with {data, data}

endmodule
