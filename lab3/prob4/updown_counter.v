`default_nettype none

module updown_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       load,
    input  wire       en,
    input  wire       up,
    input  wire [7:0] data,
    output reg  [7:0] count
);

    // TODO: Implement 8-bit up/down counter with load and async reset
    // Priority: reset > load > count (en+up/down) > hold
    // Use nonblocking assignment (<=)

endmodule
