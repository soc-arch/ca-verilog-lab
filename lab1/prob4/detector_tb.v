`default_nettype none
`timescale 1ns / 1ps

module detector_tb;

    reg  [7:0] data;
    wire       is_zero, is_neg, is_pos;

    detector uut (
        .data    (data),
        .is_zero (is_zero),
        .is_neg  (is_neg),
        .is_pos  (is_pos)
    );

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    task check;
        input exp_zero, exp_neg, exp_pos;
        begin
            test_num = test_num + 1;
            if (is_zero === exp_zero && is_neg === exp_neg && is_pos === exp_pos) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: data=%h | zero=%b(%b) neg=%b(%b) pos=%b(%b)",
                         test_num, data, is_zero, exp_zero, is_neg, exp_neg, is_pos, exp_pos);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, detector_tb);

        // Zero
        data = 8'h00; #10; check(1, 0, 0);

        // Positive values
        data = 8'h01; #10; check(0, 0, 1);
        data = 8'h7F; #10; check(0, 0, 1);  // +127
        data = 8'h42; #10; check(0, 0, 1);

        // Negative values (MSB = 1)
        data = 8'h80; #10; check(0, 1, 0);  // -128
        data = 8'hFF; #10; check(0, 1, 0);  // -1
        data = 8'hFE; #10; check(0, 1, 0);  // -2
        data = 8'hC0; #10; check(0, 1, 0);

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
