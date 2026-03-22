`default_nettype none
`timescale 1ns / 1ps

module mux4to1_tb;

    reg  [7:0] a, b, c, d;
    reg  [1:0] sel;
    wire [7:0] y;

    mux4to1 uut (
        .a   (a),
        .b   (b),
        .c   (c),
        .d   (d),
        .sel (sel),
        .y   (y)
    );

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    task check;
        input [7:0] expected;
        begin
            test_num = test_num + 1;
            if (y === expected) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: sel=%b | y=%h (exp %h)", test_num, sel, y, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, mux4to1_tb);

        a = 8'hAA; b = 8'hBB; c = 8'hCC; d = 8'hDD;

        sel = 2'b00; #10; check(8'hAA);
        sel = 2'b01; #10; check(8'hBB);
        sel = 2'b10; #10; check(8'hCC);
        sel = 2'b11; #10; check(8'hDD);

        // Change data values
        a = 8'h11; b = 8'h22; c = 8'h33; d = 8'h44;
        sel = 2'b00; #10; check(8'h11);
        sel = 2'b01; #10; check(8'h22);
        sel = 2'b10; #10; check(8'h33);
        sel = 2'b11; #10; check(8'h44);

        // Edge cases
        a = 8'h00; b = 8'hFF; c = 8'h0F; d = 8'hF0;
        sel = 2'b00; #10; check(8'h00);
        sel = 2'b11; #10; check(8'hF0);

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
