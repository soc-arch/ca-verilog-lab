`default_nettype none
`timescale 1ns / 1ps

module param_adder_tb;

    // Test with default WIDTH=8
    reg  [7:0] a8, b8;
    reg        cin8;
    wire [7:0] sum8;
    wire       cout8;

    param_adder uut_8 (
        .a    (a8),
        .b    (b8),
        .cin  (cin8),
        .sum  (sum8),
        .cout (cout8)
    );

    // Test with WIDTH=4
    reg  [3:0] a4, b4;
    reg        cin4;
    wire [3:0] sum4;
    wire       cout4;

    param_adder #(.WIDTH(4)) uut_4 (
        .a    (a4),
        .b    (b4),
        .cin  (cin4),
        .sum  (sum4),
        .cout (cout4)
    );

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    reg [8:0] expected8;
    reg [4:0] expected4;

    task check8;
        begin
            test_num = test_num + 1;
            expected8 = a8 + b8 + cin8;
            if ({cout8, sum8} === expected8[8:0]) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d (8-bit): a=%h b=%h cin=%b | {cout,sum}=%h (exp %h)",
                         test_num, a8, b8, cin8, {cout8, sum8}, expected8[8:0]);
                fail_count = fail_count + 1;
            end
        end
    endtask

    task check4;
        begin
            test_num = test_num + 1;
            expected4 = a4 + b4 + cin4;
            if ({cout4, sum4} === expected4[4:0]) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d (4-bit): a=%h b=%h cin=%b | {cout,sum}=%h (exp %h)",
                         test_num, a4, b4, cin4, {cout4, sum4}, expected4[4:0]);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, param_adder_tb);

        // 8-bit tests
        a8 = 8'h00; b8 = 8'h00; cin8 = 0; #10; check8;
        a8 = 8'hFF; b8 = 8'h01; cin8 = 0; #10; check8;  // overflow
        a8 = 8'hFF; b8 = 8'hFF; cin8 = 1; #10; check8;  // max carry
        a8 = 8'h55; b8 = 8'hAA; cin8 = 0; #10; check8;
        a8 = 8'h80; b8 = 8'h80; cin8 = 0; #10; check8;
        a8 = 8'h12; b8 = 8'h34; cin8 = 1; #10; check8;

        // 4-bit tests
        a4 = 4'h0; b4 = 4'h0; cin4 = 0; #10; check4;
        a4 = 4'hF; b4 = 4'h1; cin4 = 0; #10; check4;
        a4 = 4'hF; b4 = 4'hF; cin4 = 1; #10; check4;
        a4 = 4'h5; b4 = 4'hA; cin4 = 0; #10; check4;

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
