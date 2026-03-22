`default_nettype none
`timescale 1ns / 1ps

module halfadder_tb;

    reg  a, b;
    wire sum, cout;

    halfadder uut (
        .a    (a),
        .b    (b),
        .sum  (sum),
        .cout (cout)
    );

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    task check;
        input expected_sum;
        input expected_cout;
        begin
            test_num = test_num + 1;
            if (sum === expected_sum && cout === expected_cout) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: a=%b b=%b | sum=%b (exp %b) cout=%b (exp %b)",
                         test_num, a, b, sum, expected_sum, cout, expected_cout);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, halfadder_tb);

        // Exhaustive test: all 4 input combinations
        a = 0; b = 0; #10; check(0, 0);
        a = 0; b = 1; #10; check(1, 0);
        a = 1; b = 0; #10; check(1, 0);
        a = 1; b = 1; #10; check(0, 1);

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
