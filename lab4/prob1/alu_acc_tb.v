`default_nettype none
`timescale 1ns / 1ps

module alu_acc_tb;

    reg        clk, rst_n, en;
    reg  [7:0] b;
    reg  [2:0] op;
    wire [7:0] acc;
    wire       zero;

    alu_acc uut (
        .clk   (clk),
        .rst_n (rst_n),
        .b     (b),
        .op    (op),
        .en    (en),
        .acc   (acc),
        .zero  (zero)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    task check;
        input [7:0] exp_acc;
        input       exp_zero;
        begin
            test_num = test_num + 1;
            if (acc === exp_acc && zero === exp_zero) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: acc=%h(%h) zero=%b(%b) op=%b b=%h",
                         test_num, acc, exp_acc, zero, exp_zero, op, b);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, alu_acc_tb);

        // Reset
        rst_n = 0; en = 0; b = 0; op = 0;
        @(posedge clk); #1;
        check(8'h00, 1'b1);  // acc=0, zero=1

        rst_n = 1;

        // ADD: acc(0) + 10 = 10
        op = 3'b000; b = 8'd10; en = 1;
        @(posedge clk); #1;
        check(8'd10, 1'b0);

        // ADD: acc(10) + 20 = 30
        b = 8'd20;
        @(posedge clk); #1;
        check(8'd30, 1'b0);

        // SUB: acc(30) - 30 = 0
        op = 3'b001; b = 8'd30;
        @(posedge clk); #1;
        check(8'd0, 1'b1);

        // OR: acc(0) | 0xA5 = 0xA5
        op = 3'b011; b = 8'hA5;
        @(posedge clk); #1;
        check(8'hA5, 1'b0);

        // AND: acc(0xA5) & 0x0F = 0x05
        op = 3'b010; b = 8'h0F;
        @(posedge clk); #1;
        check(8'h05, 1'b0);

        // XOR: acc(0x05) ^ 0x05 = 0x00
        op = 3'b100; b = 8'h05;
        @(posedge clk); #1;
        check(8'h00, 1'b1);

        // OR to set value, then NOT
        op = 3'b011; b = 8'hFF;
        @(posedge clk); #1;
        check(8'hFF, 1'b0);

        op = 3'b101; b = 8'h00;  // NOT acc
        @(posedge clk); #1;
        check(8'h00, 1'b1);

        // SLL: load 0x01, shift left
        op = 3'b011; b = 8'h01;
        @(posedge clk); #1;
        check(8'h01, 1'b0);

        op = 3'b110; // SLL
        @(posedge clk); #1;
        check(8'h02, 1'b0);

        // SRL
        op = 3'b111; // SRL
        @(posedge clk); #1;
        check(8'h01, 1'b0);

        // Test en=0 (hold)
        en = 0; op = 3'b000; b = 8'hFF;
        @(posedge clk); #1;
        check(8'h01, 1'b0);  // should hold

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
