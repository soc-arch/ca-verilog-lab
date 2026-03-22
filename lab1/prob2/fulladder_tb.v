`default_nettype none
`timescale 1ns / 1ps

module fulladder_tb;

    reg  a, b, cin;
    wire sum, cout;

    fulladder uut (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (sum),
        .cout (cout)
    );

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;
    integer i;

    reg expected_sum, expected_cout;

    task check;
        input exp_sum;
        input exp_cout;
        begin
            test_num = test_num + 1;
            if (sum === exp_sum && cout === exp_cout) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: a=%b b=%b cin=%b | sum=%b (exp %b) cout=%b (exp %b)",
                         test_num, a, b, cin, sum, exp_sum, cout, exp_cout);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, fulladder_tb);

        // Exhaustive test: all 8 input combinations
        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i[2:0];
            #10;
            {expected_cout, expected_sum} = a + b + cin;
            check(expected_sum, expected_cout);
        end

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
