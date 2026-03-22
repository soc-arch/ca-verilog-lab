`default_nettype none
`timescale 1ns / 1ps

module alu_tb;

    reg  [7:0] a, b;
    reg  [2:0] op;
    wire [7:0] y;
    wire       zero;

    alu uut (
        .a    (a),
        .b    (b),
        .op   (op),
        .y    (y),
        .zero (zero)
    );

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    task check;
        input [7:0] exp_y;
        input       exp_zero;
        begin
            test_num = test_num + 1;
            if (y === exp_y && zero === exp_zero) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: a=%h b=%h op=%b | y=%h(%h) zero=%b(%b)",
                         test_num, a, b, op, y, exp_y, zero, exp_zero);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, alu_tb);

        // ADD
        a = 8'h10; b = 8'h20; op = 3'b000; #10; check(8'h30, 1'b0);
        a = 8'hFF; b = 8'h01; op = 3'b000; #10; check(8'h00, 1'b1);  // overflow, zero

        // SUB
        a = 8'h30; b = 8'h10; op = 3'b001; #10; check(8'h20, 1'b0);
        a = 8'h05; b = 8'h05; op = 3'b001; #10; check(8'h00, 1'b1);  // zero

        // AND
        a = 8'hA5; b = 8'h5A; op = 3'b010; #10; check(8'h00, 1'b1);
        a = 8'hFF; b = 8'h0F; op = 3'b010; #10; check(8'h0F, 1'b0);

        // OR
        a = 8'hA0; b = 8'h0B; op = 3'b011; #10; check(8'hAB, 1'b0);
        a = 8'h00; b = 8'h00; op = 3'b011; #10; check(8'h00, 1'b1);

        // XOR
        a = 8'hFF; b = 8'hFF; op = 3'b100; #10; check(8'h00, 1'b1);
        a = 8'hA5; b = 8'h5A; op = 3'b100; #10; check(8'hFF, 1'b0);

        // NOT
        a = 8'hFF; b = 8'h00; op = 3'b101; #10; check(8'h00, 1'b1);
        a = 8'h00; b = 8'h00; op = 3'b101; #10; check(8'hFF, 1'b0);

        // SLL
        a = 8'h01; b = 8'h00; op = 3'b110; #10; check(8'h02, 1'b0);
        a = 8'h80; b = 8'h00; op = 3'b110; #10; check(8'h00, 1'b1);

        // SRL
        a = 8'h02; b = 8'h00; op = 3'b111; #10; check(8'h01, 1'b0);
        a = 8'h01; b = 8'h00; op = 3'b111; #10; check(8'h00, 1'b1);

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
