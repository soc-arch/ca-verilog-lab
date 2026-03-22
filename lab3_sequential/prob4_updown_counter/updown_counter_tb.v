`default_nettype none
`timescale 1ns / 1ps

module updown_counter_tb;

    reg        clk, rst_n, load, en, up;
    reg  [7:0] data;
    wire [7:0] count;

    updown_counter uut (
        .clk   (clk),
        .rst_n (rst_n),
        .load  (load),
        .en    (en),
        .up    (up),
        .data  (data),
        .count (count)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    task check;
        input [7:0] expected;
        begin
            test_num = test_num + 1;
            if (count === expected) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: count=%0d (exp %0d) at time %0t",
                         test_num, count, expected, $time);
                fail_count = fail_count + 1;
            end
        end
    endtask

    integer i;

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, updown_counter_tb);

        // Reset
        rst_n = 0; load = 0; en = 0; up = 1; data = 8'd0;
        @(posedge clk); #1;
        check(8'd0);

        // Release reset, count up
        rst_n = 1; en = 1; up = 1;
        for (i = 1; i <= 5; i = i + 1) begin
            @(posedge clk); #1;
            check(i[7:0]);
        end

        // Count down
        up = 0;
        for (i = 4; i >= 0; i = i - 1) begin
            @(posedge clk); #1;
            check(i[7:0]);
        end

        // Load value
        load = 1; data = 8'd100;
        @(posedge clk); #1;
        check(8'd100);

        // Load has priority over count
        en = 1; up = 1; data = 8'd200;
        @(posedge clk); #1;
        check(8'd200);

        // Release load, count up from loaded value
        load = 0;
        @(posedge clk); #1; check(8'd201);
        @(posedge clk); #1; check(8'd202);

        // Disable counting — hold
        en = 0;
        @(posedge clk); #1; check(8'd202);
        @(posedge clk); #1; check(8'd202);

        // Overflow test
        en = 1; up = 1; load = 1; data = 8'hFE;
        @(posedge clk); #1; check(8'hFE);
        load = 0;
        @(posedge clk); #1; check(8'hFF);
        @(posedge clk); #1; check(8'h00);  // wrap

        // Underflow test
        up = 0;
        @(posedge clk); #1; check(8'hFF);  // wrap down

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
