`default_nettype none

module good_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       en,
    input  wire [1:0] mode,
    input  wire [7:0] load_val,
    output reg  [7:0] count,
    output wire       is_zero
);

    // TODO: Fix all issues from bad_counter.v and implement correctly
    //
    // Expected behavior:
    //   rst_n=0 → count=0
    //   en=1, mode=00 → hold
    //   en=1, mode=01 → count up
    //   en=1, mode=10 → count down
    //   en=1, mode=11 → load load_val
    //   en=0 → hold
    //
    // Requirements:
    //   1. `default_nettype none (already done above)
    //   2. snake_case naming (already done in port list)
    //   3. _n suffix for active-low reset
    //   4. Proper if/else chain (not multiple if)
    //   5. Nonblocking assignment (<=) in sequential block
    //   6. Combinational zero flag with assign

endmodule
