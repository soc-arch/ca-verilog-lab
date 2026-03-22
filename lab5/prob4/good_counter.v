`default_nettype none

module good_counter (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       en,
    input  logic [1:0] mode,
    input  logic [7:0] load_val,
    output logic [7:0] count,
    output logic       is_zero
);

    // TODO: Fix bad_counter.v issues AND convert to SystemVerilog
    //
    // Checklist:
    //   [ ] logic instead of wire/reg
    //   [ ] always_ff for sequential logic
    //   [ ] snake_case naming (already done in port list)
    //   [ ] _n suffix for active-low reset
    //   [ ] Proper if/else chain (not multiple if)
    //   [ ] Nonblocking assignment (<=) in always_ff
    //   [ ] assign for zero flag

endmodule
