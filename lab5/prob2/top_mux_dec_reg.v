`default_nettype none

module top_mux_dec_reg (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] wdata,
    input  logic [1:0] waddr,
    input  logic       we,
    input  logic [1:0] raddr,
    output logic [7:0] rdata
);

    // TODO: Instantiate sub-modules using dot-name (.name) port connections
    //
    // Use .name for ports where signal name matches port name:
    //   decoder2to4 u_dec (
    //       .in  (waddr),
    //       .en  (we),      // or .en if local signal is also named 'en'
    //       .out (we_vec)
    //   );
    //
    //   register8 u_reg0 (
    //       .clk,           // dot-name: clk matches clk
    //       .rst_n,         // dot-name: rst_n matches rst_n
    //       .we  (we_vec[0]),
    //       .d   (wdata),
    //       .q   (reg0_q)
    //   );
    //
    // Remember: logic for all internal wires (no wire/reg distinction)

endmodule
