`default_nettype none
`timescale 1ns / 1ps

module priority_enc_tb;

    reg  [3:0] req;
    wire [1:0] enc;
    wire       valid;

    priority_enc uut (
        .req   (req),
        .enc   (enc),
        .valid (valid)
    );

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;
    integer i;

    task check;
        input [1:0] exp_enc;
        input       exp_valid;
        begin
            test_num = test_num + 1;
            if (enc === exp_enc && valid === exp_valid) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: req=%b | enc=%d(%d) valid=%b(%b)",
                         test_num, req, enc, exp_enc, valid, exp_valid);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, priority_enc_tb);

        // No request
        req = 4'b0000; #10; check(2'd0, 1'b0);

        // Single requests
        req = 4'b0001; #10; check(2'd0, 1'b1);
        req = 4'b0010; #10; check(2'd1, 1'b1);
        req = 4'b0100; #10; check(2'd2, 1'b1);
        req = 4'b1000; #10; check(2'd3, 1'b1);

        // Priority: higher bits override lower
        req = 4'b0011; #10; check(2'd1, 1'b1);
        req = 4'b0110; #10; check(2'd2, 1'b1);
        req = 4'b1100; #10; check(2'd3, 1'b1);
        req = 4'b1111; #10; check(2'd3, 1'b1);
        req = 4'b0111; #10; check(2'd2, 1'b1);
        req = 4'b1010; #10; check(2'd3, 1'b1);
        req = 4'b0101; #10; check(2'd2, 1'b1);

        // Exhaustive test remaining patterns
        for (i = 0; i < 16; i = i + 1) begin
            req = i[3:0]; #10;
            if (req == 4'b0000) check(2'd0, 1'b0);
            else if (req[3])   check(2'd3, 1'b1);
            else if (req[2])   check(2'd2, 1'b1);
            else if (req[1])   check(2'd1, 1'b1);
            else               check(2'd0, 1'b1);
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
