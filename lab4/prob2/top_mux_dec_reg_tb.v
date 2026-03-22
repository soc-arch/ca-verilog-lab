`default_nettype none
`timescale 1ns / 1ps

module top_mux_dec_reg_tb;

    reg        clk, rst_n, we;
    reg  [7:0] wdata;
    reg  [1:0] waddr, raddr;
    wire [7:0] rdata;

    top_mux_dec_reg uut (
        .clk   (clk),
        .rst_n (rst_n),
        .wdata (wdata),
        .waddr (waddr),
        .we    (we),
        .raddr (raddr),
        .rdata (rdata)
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
            if (rdata === expected) begin
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL test %0d: raddr=%0d | rdata=%h (exp %h)",
                         test_num, raddr, rdata, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    integer i;

    initial begin
        $dumpfile("dump.fst");
        $dumpvars(0, top_mux_dec_reg_tb);

        // Reset
        rst_n = 0; we = 0; wdata = 0; waddr = 0; raddr = 0;
        @(posedge clk); @(posedge clk);
        rst_n = 1;

        // Read all registers after reset — should be 0
        for (i = 0; i < 4; i = i + 1) begin
            raddr = i[1:0]; #1; check(8'h00);
        end

        // Write different values to each register
        we = 1;
        waddr = 2'd0; wdata = 8'hAA; @(posedge clk); #1;
        waddr = 2'd1; wdata = 8'hBB; @(posedge clk); #1;
        waddr = 2'd2; wdata = 8'hCC; @(posedge clk); #1;
        waddr = 2'd3; wdata = 8'hDD; @(posedge clk); #1;
        we = 0;

        // Read back all registers
        raddr = 2'd0; #1; check(8'hAA);
        raddr = 2'd1; #1; check(8'hBB);
        raddr = 2'd2; #1; check(8'hCC);
        raddr = 2'd3; #1; check(8'hDD);

        // Overwrite reg1 only
        we = 1; waddr = 2'd1; wdata = 8'h42;
        @(posedge clk); #1;
        we = 0;

        raddr = 2'd0; #1; check(8'hAA);  // unchanged
        raddr = 2'd1; #1; check(8'h42);  // updated
        raddr = 2'd2; #1; check(8'hCC);  // unchanged
        raddr = 2'd3; #1; check(8'hDD);  // unchanged

        // Write disable test — value should not change
        we = 0; waddr = 2'd0; wdata = 8'hFF;
        @(posedge clk); #1;
        raddr = 2'd0; #1; check(8'hAA);  // still AA

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
