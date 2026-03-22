`default_nettype none
`timescale 1ns / 1ps

module shift_reg_tb;

    reg        clk, rst_n, serial_in;
    wire [7:0] parallel_out;

    shift_reg uut (
        .clk          (clk),
        .rst_n        (rst_n),
        .serial_in    (serial_in),
        .parallel_out (parallel_out)
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
            if (parallel_out === expected) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: parallel_out=%h (exp %h) at time %0t",
                         test_num, parallel_out, expected, $time);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, shift_reg_tb);

        // Reset
        rst_n = 0; serial_in = 0;
        @(posedge clk); #1;
        check(8'h00);

        rst_n = 1;

        // Shift in 8'b10110010 (MSB first)
        serial_in = 1; @(posedge clk); #1; check(8'b00000001);
        serial_in = 0; @(posedge clk); #1; check(8'b00000010);
        serial_in = 1; @(posedge clk); #1; check(8'b00000101);
        serial_in = 1; @(posedge clk); #1; check(8'b00001011);
        serial_in = 0; @(posedge clk); #1; check(8'b00010110);
        serial_in = 0; @(posedge clk); #1; check(8'b00101100);
        serial_in = 1; @(posedge clk); #1; check(8'b01011001);
        serial_in = 0; @(posedge clk); #1; check(8'b10110010);

        // Continue shifting — old bits fall off MSB
        serial_in = 1; @(posedge clk); #1; check(8'b01100101);
        serial_in = 1; @(posedge clk); #1; check(8'b11001011);

        // Reset mid-operation
        rst_n = 0; #1;
        check(8'h00);

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
