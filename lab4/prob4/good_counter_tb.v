`default_nettype none
`timescale 1ns / 1ps

module good_counter_tb;

    reg        clk, rst_n, en;
    reg  [1:0] mode;
    reg  [7:0] load_val;
    wire [7:0] count;
    wire       is_zero;

    good_counter uut (
        .clk      (clk),
        .rst_n    (rst_n),
        .en       (en),
        .mode     (mode),
        .load_val (load_val),
        .count    (count),
        .is_zero  (is_zero)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    task check;
        input [7:0] exp_count;
        input       exp_zero;
        begin
            test_num = test_num + 1;
            if (count === exp_count && is_zero === exp_zero) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: count=%0d(%0d) is_zero=%b(%b) mode=%b en=%b",
                         test_num, count, exp_count, is_zero, exp_zero, mode, en);
                fail_count = fail_count + 1;
            end
        end
    endtask

    integer i;

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, good_counter_tb);

        // Reset
        rst_n = 0; en = 0; mode = 2'b00; load_val = 8'd0;
        @(posedge clk); #1;
        check(8'd0, 1'b1);

        rst_n = 1;

        // Hold mode (en=1, mode=00) — count should stay 0
        en = 1; mode = 2'b00;
        @(posedge clk); #1;
        check(8'd0, 1'b1);

        // Count up
        mode = 2'b01;
        for (i = 1; i <= 5; i = i + 1) begin
            @(posedge clk); #1;
            check(i[7:0], (i == 0));
        end

        // Count down
        mode = 2'b10;
        for (i = 4; i >= 0; i = i - 1) begin
            @(posedge clk); #1;
            check(i[7:0], (i == 0));
        end

        // Load value
        mode = 2'b11; load_val = 8'd100;
        @(posedge clk); #1;
        check(8'd100, 1'b0);

        // Count up from loaded value
        mode = 2'b01;
        @(posedge clk); #1; check(8'd101, 1'b0);

        // Disable (en=0) — should hold
        en = 0; mode = 2'b01;
        @(posedge clk); #1; check(8'd101, 1'b0);
        @(posedge clk); #1; check(8'd101, 1'b0);

        // Re-enable
        en = 1;
        @(posedge clk); #1; check(8'd102, 1'b0);

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
