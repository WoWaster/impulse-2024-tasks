module f32_adder_tb ();
  logic clk, rst;
  logic [31:0] a, b, c, c_expected;
  logic invalid, overflow, underflow, inexact;
  logic invalid_expected, overflow_expected, underflow_expected, inexact_expected;
  logic [31:0] vectornum, errors;
  logic [99:0] testvectors[10];

  f32_adder dut (
      .a,
      .b,
      .c,
      .invalid,
      .overflow,
      .underflow,
      .inexact
  );

  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end

  initial begin
    /* a, b, c_expected, invalid_expected,
       overflow_expected, underflow_expected, inexact_expected
    */
    $readmemb("src/f32_adder.tv", testvectors);
    vectornum = 0;
    errors = 0;
    rst = 1;
    #25;
    rst = 0;
  end

  always @(posedge clk) begin
    #1;
    {a, b, c_expected, invalid_expected,
    overflow_expected, underflow_expected, inexact_expected} = testvectors[vectornum];
  end

  always @(negedge clk)
    if (~rst) begin
      if (c === c_expected && invalid === invalid_expected && overflow === overflow_expected
        && underflow === underflow_expected && inexact === inexact_expected) begin
        $display("PASSED: %b + %b = %b [%b%b%b%b]", a, b, c, invalid, overflow, underflow, inexact);
      end else begin
        $display("FAILED: inputs = %b + %b", a, b);
        $display("\toutputs = %b [%b%b%b%b] (%b [%b%b%b%b] expected)", c, invalid, overflow,
                 underflow, inexact, c_expected, invalid_expected, overflow_expected,
                 underflow_expected, inexact_expected);
        errors = errors + 1;
      end
      vectornum = vectornum + 1;
      if (testvectors[vectornum] === 'bx) begin
        $display("\n%d tests completed with %d failed", vectornum, errors);
        $finish;
      end
    end
endmodule
