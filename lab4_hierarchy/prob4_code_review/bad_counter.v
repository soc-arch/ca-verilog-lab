// BAD CODE — DO NOT USE AS REFERENCE
// This file contains intentional style and correctness violations.
// Your task: fix all issues and write the corrected version in good_counter.v

module BadCounter(
    input Clk,
    input resetN,
    input Enable,
    input [1:0] Mode,     // 00=hold, 01=up, 10=down, 11=load
    input [7:0] LoadVal,
    output reg [7:0] Count,
    output IsZero
);

assign IsZero = (Count == 0);

always @(posedge Clk or negedge resetN) begin
    if (!resetN)
        Count <= 0;
    else if (Enable) begin
        if (Mode == 2'b01)
            Count <= Count + 1;
        if (Mode == 2'b10)
            Count <= Count - 1;
        if (Mode == 2'b11)
            Count <= LoadVal;
        // BUG: Mode==00 is not handled → what happens?
        // BUG: Multiple if statements instead of if/else chain
        //      (works here by accident but bad practice)
    end
end

// STYLE VIOLATIONS:
// 1. No `default_nettype none
// 2. CamelCase naming (BadCounter, Clk, resetN, Enable, etc.)
// 3. Mixed naming styles (resetN vs Enable)
// 4. Module name doesn't match expected file naming convention
// 5. No clear separation of combinational and sequential logic
//    (IsZero assign is fine, but commenting/organization is poor)
// 6. Multiple if instead of if/else chain in sequential block

endmodule
