`default_nettype none
`timescale 1ns / 1ps

module seven_seg_tb;

    reg  [3:0] bcd;
    wire [6:0] seg;

    seven_seg uut (
        .bcd (bcd),
        .seg (seg)
    );

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    // Display 7-segment shape in console
    // seg[6:0] = {g, f, e, d, c, b, a}
    //
    //   aaa
    //  f   b
    //   ggg
    //  e   c
    //   ddd
    //
    task display_seg;
        begin
            $display("  BCD = %0d    seg = %07b", bcd, seg);
            $display("   %s%s%s",
                     seg[0] ? "*" : " ", seg[0] ? "*" : " ", seg[0] ? "*" : " ");
            $display("  %s   %s",
                     seg[5] ? "*" : " ", seg[1] ? "*" : " ");
            $display("   %s%s%s",
                     seg[6] ? "*" : " ", seg[6] ? "*" : " ", seg[6] ? "*" : " ");
            $display("  %s   %s",
                     seg[4] ? "*" : " ", seg[2] ? "*" : " ");
            $display("   %s%s%s",
                     seg[3] ? "*" : " ", seg[3] ? "*" : " ", seg[3] ? "*" : " ");
            $display("");
        end
    endtask

    task check;
        input [6:0] exp;
        begin
            test_num = test_num + 1;
            if (seg === exp) begin
                pass_count = pass_count + 1;
                display_seg;
            end else begin
                $display("FAIL test %0d: bcd=%0d | seg=%07b (exp %07b)", test_num, bcd, seg, exp);
                display_seg;
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, seven_seg_tb);

        bcd = 4'd0;  #10; check(7'b0111111);
        bcd = 4'd1;  #10; check(7'b0000110);
        bcd = 4'd2;  #10; check(7'b1011011);
        bcd = 4'd3;  #10; check(7'b1001111);
        bcd = 4'd4;  #10; check(7'b1100110);
        bcd = 4'd5;  #10; check(7'b1101101);
        bcd = 4'd6;  #10; check(7'b1111101);
        bcd = 4'd7;  #10; check(7'b0000111);
        bcd = 4'd8;  #10; check(7'b1111111);
        bcd = 4'd9;  #10; check(7'b1101111);

        // Invalid BCD inputs (should be blank)
        bcd = 4'd10; #10; check(7'b0000000);
        bcd = 4'd11; #10; check(7'b0000000);
        bcd = 4'd15; #10; check(7'b0000000);

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
