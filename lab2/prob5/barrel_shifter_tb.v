`default_nettype none
`timescale 1ns / 1ps

module barrel_shifter_tb;

    reg  [7:0] data;
    reg  [2:0] shamt;
    wire [7:0] y;

    barrel_shifter uut (
        .data  (data),
        .shamt (shamt),
        .y     (y)
    );

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    // Reference: left rotate
    reg [15:0] doubled;
    reg [7:0]  expected;

    task check;
        begin
            test_num = test_num + 1;
            doubled = {data, data};
            expected = doubled[15-shamt -: 8];
            if (y === expected) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: data=%h shamt=%0d | y=%h (exp %h)",
                         test_num, data, shamt, y, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    integer i;

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, barrel_shifter_tb);

        // Test all shift amounts with known pattern
        data = 8'b10000001;
        for (i = 0; i < 8; i = i + 1) begin
            shamt = i[2:0]; #10; check;
        end

        // Another pattern
        data = 8'hA5;
        for (i = 0; i < 8; i = i + 1) begin
            shamt = i[2:0]; #10; check;
        end

        // Edge case: all ones
        data = 8'hFF;
        for (i = 0; i < 8; i = i + 1) begin
            shamt = i[2:0]; #10; check;
        end

        // Edge case: all zeros
        data = 8'h00;
        shamt = 3'd3; #10; check;

        #10;
        $display("==================================================");
        if (fail_count == 0)
            $display("All tests passed! (%0d/%0d)", pass_count, pass_count);
        else
            $display("FAILED: %0d/%0d tests passed", pass_count, pass_count + fail_count);
        $display("==================================================");
        $finish;
    end

endmodule
