`default_nettype none

module priority_enc (
    input  wire [3:0] req,
    output reg  [1:0] enc,
    output reg        valid
);

    // TODO: Implement priority encoder using always @(*) with if/else
    // req[3] has highest priority, req[0] has lowest
    // Don't forget default assignments to prevent latch inference!

endmodule
