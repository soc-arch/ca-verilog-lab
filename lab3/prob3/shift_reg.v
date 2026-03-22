`default_nettype none

module shift_reg (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       serial_in,
    output reg  [7:0] parallel_out
);

    // TODO: Implement 8-bit Serial-In Parallel-Out shift register
    // On each clock edge: shift left by 1, serial_in enters at LSB
    // parallel_out <= {parallel_out[6:0], serial_in}

endmodule
