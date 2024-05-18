`include "HardFloat_consts.vi"
module f32_adder (
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] c,
    output logic invalid,
    output logic overflow,
    output logic underflow,
    output logic inexact
);

  logic [32:0] ra, rb, rc;  // Floats in HardFloat's recorded format

  fNToRecFN #(
      .expWidth(8),
      .sigWidth(24)
  ) faToRecFa (
      .in (a),
      .out(ra)
  );

  fNToRecFN #(
      .expWidth(8),
      .sigWidth(24)
  ) fbToRecFb (
      .in (b),
      .out(rb)
  );

  addRecFN #(
      .expWidth(8),
      .sigWidth(24)
  ) addRecFc (
      .control       (`flControl_tininessAfterRounding),
      .subOp         (1'b0),                                       // 0 selects addition
      .a             (ra),
      .b             (rb),
      .roundingMode  (`round_near_even),
      .out           (rc),
      .exceptionFlags({invalid, _, overflow, underflow, inexact})
  );

  recFNToFN #(
      .expWidth(8),
      .sigWidth(24)
  ) recFcToFc (
      .in (rc),
      .out(c)
  );

endmodule
