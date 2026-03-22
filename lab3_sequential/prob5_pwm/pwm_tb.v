`default_nettype none
`timescale 1ns / 1ps

module pwm_tb;

    reg        clk, rst_n;
    reg  [7:0] duty;
    wire       pwm_out;

    pwm uut (
        .clk     (clk),
        .rst_n   (rst_n),
        .duty    (duty),
        .pwm_out (pwm_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    // Count high cycles in one full PWM period (256 clocks)
    integer high_count;
    integer i;

    task check_duty;
        input [7:0] expected_highs;
        begin
            test_num = test_num + 1;
            if (high_count == expected_highs) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: duty=%0d | high_cycles=%0d (exp %0d)",
                         test_num, duty, high_count, expected_highs);
                fail_count = fail_count + 1;
            end
        end
    endtask

    task run_one_period;
        begin
            high_count = 0;
            for (i = 0; i < 256; i = i + 1) begin
                @(posedge clk); #1;
                if (pwm_out) high_count = high_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, pwm_tb);

        // Reset
        rst_n = 0; duty = 8'd0;
        @(posedge clk); @(posedge clk);
        rst_n = 1;

        // duty=0 → always low
        duty = 8'd0;
        run_one_period;
        check_duty(8'd0);

        // duty=128 → 50% duty cycle
        duty = 8'd128;
        run_one_period;
        check_duty(8'd128);

        // duty=255 → almost always high (255/256)
        duty = 8'd255;
        run_one_period;
        check_duty(8'd255);

        // duty=1 → 1/256
        duty = 8'd1;
        run_one_period;
        check_duty(8'd1);

        // duty=64 → 25%
        duty = 8'd64;
        run_one_period;
        check_duty(8'd64);

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
