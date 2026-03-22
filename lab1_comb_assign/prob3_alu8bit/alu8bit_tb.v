`default_nettype none
`timescale 1ns / 1ps

module alu8bit_tb;

    reg  [7:0] a, b;
    reg  [1:0] op;
    wire [7:0] y;

    alu8bit uut (
        .a  (a),
        .b  (b),
        .op (op),
        .y  (y)
    );

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    reg [7:0] expected;

    task check;
        begin
            test_num = test_num + 1;
            if (y === expected) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: a=%h b=%h op=%b | y=%h (exp %h)",
                         test_num, a, b, op, y, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, alu8bit_tb);

        // Test AND
        a = 8'hA5; b = 8'h5A; op = 2'b00; #10; expected = 8'hA5 & 8'h5A; check;
        a = 8'hFF; b = 8'h0F; op = 2'b00; #10; expected = 8'hFF & 8'h0F; check;

        // Test OR
        a = 8'hA5; b = 8'h5A; op = 2'b01; #10; expected = 8'hA5 | 8'h5A; check;
        a = 8'h00; b = 8'hF0; op = 2'b01; #10; expected = 8'h00 | 8'hF0; check;

        // Test XOR
        a = 8'hA5; b = 8'h5A; op = 2'b10; #10; expected = 8'hA5 ^ 8'h5A; check;
        a = 8'hFF; b = 8'hFF; op = 2'b10; #10; expected = 8'hFF ^ 8'hFF; check;

        // Test NOT A
        a = 8'hA5; b = 8'h00; op = 2'b11; #10; expected = ~8'hA5; check;
        a = 8'h00; b = 8'hFF; op = 2'b11; #10; expected = ~8'h00; check;

        // Edge cases
        a = 8'h00; b = 8'h00; op = 2'b00; #10; expected = 8'h00; check;
        a = 8'hFF; b = 8'hFF; op = 2'b01; #10; expected = 8'hFF; check;

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
