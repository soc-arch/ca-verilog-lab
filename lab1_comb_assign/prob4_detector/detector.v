`default_nettype none

module detector (
    input  wire [7:0] data,
    output wire       is_zero,
    output wire       is_neg,
    output wire       is_pos
);

    // TODO: Implement zero/sign detector using assign statements
    // is_zero = 1 when data == 8'b0
    // is_neg  = 1 when data[7] == 1 (MSB indicates negative in signed representation)
    // is_pos  = 1 when data is not zero and not negative

    // Hint: Use reduction OR operator (|data) and bit-select (data[7])

endmodule
