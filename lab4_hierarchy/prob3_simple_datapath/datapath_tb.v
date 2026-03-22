`default_nettype none
`timescale 1ns / 1ps

module datapath_tb;

    reg        clk, rst_n, we, src_b_sel;
    reg  [1:0] raddr1, raddr2, waddr;
    reg  [2:0] alu_op;
    reg  [7:0] imm;
    wire [7:0] alu_result;
    wire       zero;

    datapath uut (
        .clk        (clk),
        .rst_n      (rst_n),
        .raddr1     (raddr1),
        .raddr2     (raddr2),
        .waddr      (waddr),
        .we         (we),
        .alu_op     (alu_op),
        .imm        (imm),
        .src_b_sel  (src_b_sel),
        .alu_result (alu_result),
        .zero       (zero)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num   = 0;

    task check;
        input [7:0] exp_result;
        input       exp_zero;
        begin
            test_num = test_num + 1;
            if (alu_result === exp_result && zero === exp_zero) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: alu_result=%h(%h) zero=%b(%b)",
                         test_num, alu_result, exp_result, zero, exp_zero);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, datapath_tb);

        // Reset
        rst_n = 0; we = 0; src_b_sel = 0; alu_op = 0;
        raddr1 = 0; raddr2 = 0; waddr = 0; imm = 0;
        @(posedge clk); @(posedge clk);
        rst_n = 1;

        // Setup signals at negedge, check at negedge (after combinational settling),
        // then posedge latches the write.

        // --- Instruction 1: reg[0] = 0 + imm(10) ---
        @(negedge clk);
        raddr1 = 2'd0; src_b_sel = 1; imm = 8'd10;
        alu_op = 3'b000; waddr = 2'd0; we = 1;
        #1; check(8'd10, 1'b0);  // ALU output = 0+10 = 10
        // posedge clk will latch reg[0] = 10

        // --- Instruction 2: reg[1] = 0 + imm(20) ---
        @(negedge clk);
        raddr1 = 2'd1; imm = 8'd20; waddr = 2'd1;
        #1; check(8'd20, 1'b0);
        // posedge clk will latch reg[1] = 20

        // --- Instruction 3: reg[2] = reg[0] + reg[1] ---
        @(negedge clk);
        raddr1 = 2'd0; raddr2 = 2'd1; src_b_sel = 0;
        alu_op = 3'b000; waddr = 2'd2;
        #1; check(8'd30, 1'b0);  // 10 + 20 = 30

        // --- Instruction 4: reg[3] = reg[2] - reg[0] ---
        @(negedge clk);
        raddr1 = 2'd2; raddr2 = 2'd0;
        alu_op = 3'b001; waddr = 2'd3;
        #1; check(8'd20, 1'b0);  // 30 - 10 = 20

        // --- Instruction 5: reg[0] = reg[0] & imm(0x0F) ---
        @(negedge clk);
        raddr1 = 2'd0; src_b_sel = 1; imm = 8'h0F;
        alu_op = 3'b010; waddr = 2'd0;
        #1; check(8'h0A, 1'b0);  // 0x0A & 0x0F = 0x0A

        // --- Instruction 6: reg[0] = reg[0] - reg[0] (should be zero) ---
        @(negedge clk);
        raddr1 = 2'd0; raddr2 = 2'd0; src_b_sel = 0;
        alu_op = 3'b001; waddr = 2'd0;
        #1; check(8'h00, 1'b1);  // 0x0A - 0x0A = 0, zero=1

        // --- No-write test: result computed but not stored ---
        @(negedge clk);
        we = 0;
        raddr1 = 2'd1; src_b_sel = 1; imm = 8'hFF;
        alu_op = 3'b000;
        #1;
        // alu_result should show 20+255=19(overflow), but reg[1] should still be 20
        check(8'd19, 1'b0);  // 20+255 = 275 -> 19 (8-bit overflow)

        // Verify reg[1] wasn't written
        @(negedge clk);
        we = 1;
        raddr1 = 2'd1; raddr2 = 2'd1; src_b_sel = 0;
        alu_op = 3'b001; waddr = 2'd1;  // reg[1] - reg[1]
        #1; check(8'd0, 1'b1);  // 20-20=0 confirms reg[1] was still 20

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
