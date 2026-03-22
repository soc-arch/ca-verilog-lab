`default_nettype none
`timescale 1ns / 1ps

module dff_tb;

    reg  clk, rst_n, d;
    wire q;

    dff uut (
        .clk   (clk),
        .rst_n (rst_n),
        .d     (d),
        .q     (q)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    task check;
        input expected_q;
        begin
            test_num = test_num + 1;
            if (q === expected_q) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: d=%b rst_n=%b | q=%b (exp %b) at time %0t",
                         test_num, d, rst_n, q, expected_q, $time);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, dff_tb);

        // Initialize
        rst_n = 0; d = 0;
        @(posedge clk); #1;
        check(1'b0);  // reset active

        // Release reset
        rst_n = 1;

        // Load 1
        d = 1;
        @(posedge clk); #1;
        check(1'b1);

        // Load 0
        d = 0;
        @(posedge clk); #1;
        check(1'b0);

        // Load 1 again
        d = 1;
        @(posedge clk); #1;
        check(1'b1);

        // Hold (d stays 1)
        @(posedge clk); #1;
        check(1'b1);

        // Async reset while d=1
        rst_n = 0; #1;
        check(1'b0);  // should reset immediately

        rst_n = 1; d = 1;
        @(posedge clk); #1;
        check(1'b1);

        // Toggle d rapidly
        d = 0; @(posedge clk); #1; check(1'b0);
        d = 1; @(posedge clk); #1; check(1'b1);
        d = 0; @(posedge clk); #1; check(1'b0);

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
