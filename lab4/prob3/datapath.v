`default_nettype none

module datapath (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] raddr1,
    input  wire [1:0] raddr2,
    input  wire [1:0] waddr,
    input  wire       we,
    input  wire [2:0] alu_op,
    input  wire [7:0] imm,
    input  wire       src_b_sel,
    output wire [7:0] alu_result,
    output wire       zero
);

    // TODO: Instantiate and connect sub-modules
    //
    // Internal wires:
    //   wire [7:0] rdata1, rdata2;  // register file outputs
    //   wire [7:0] alu_b;           // MUX output → ALU input B
    //
    // 1. Register File
    //   reg_file u_rf (
    //     .clk(clk), .rst_n(rst_n),
    //     .raddr1(raddr1), .raddr2(raddr2),
    //     .waddr(waddr), .wdata(alu_result), .we(we),
    //     .rdata1(rdata1), .rdata2(rdata2)
    //   );
    //
    // 2. Source B MUX: select between rdata2 and immediate
    //   mux2to1_8bit u_mux_b (
    //     .a(rdata2), .b(imm), .sel(src_b_sel), .y(alu_b)
    //   );
    //
    // 3. ALU
    //   alu_unit u_alu (
    //     .a(rdata1), .b(alu_b), .op(alu_op),
    //     .y(alu_result), .zero(zero)
    //   );

endmodule
