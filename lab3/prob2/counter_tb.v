`default_nettype none
`timescale 1ns / 1ps

module counter_tb;

    reg        clk, rst_n, en;
    wire [3:0] count;

    counter uut (
        .clk   (clk),
        .rst_n (rst_n),
        .en    (en),
        .count (count)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    task check;
        input [3:0] expected;
        begin
            test_num = test_num + 1;
            if (count === expected) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: en=%b | count=%0d (exp %0d) at time %0t",
                         test_num, en, count, expected, $time);
                fail_count = fail_count + 1;
            end
        end
    endtask

    integer i;

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, counter_tb);

        // Reset
        rst_n = 0; en = 0;
        @(posedge clk); #1;
        check(4'd0);

        // Release reset, enable counting
        rst_n = 1; en = 1;
        for (i = 1; i <= 16; i = i + 1) begin
            @(posedge clk); #1;
            check(i[3:0]);  // wraps at 16 → 0
        end

        // Disable counting — should hold
        en = 0;
        @(posedge clk); #1;
        check(4'd0);  // wrapped to 0, then held
        @(posedge clk); #1;
        check(4'd0);  // still held

        // Re-enable
        en = 1;
        @(posedge clk); #1;
        check(4'd1);
        @(posedge clk); #1;
        check(4'd2);

        // Async reset during counting
        rst_n = 0; #1;
        check(4'd0);
        rst_n = 1;

        @(posedge clk); #1;
        check(4'd1);

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
