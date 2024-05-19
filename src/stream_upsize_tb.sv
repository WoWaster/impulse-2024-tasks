module stream_upsize_tb ();
  logic clk, reset, s_last_i, s_valid_i, s_ready_o, m_last_o, m_valid_o;
  logic [3:0] s_data_i, m_data_o[2];
  logic [1:0] m_keep_o;
  logic [31:0] vectornum, errors;
  logic [5:0] testvectors[7];

  stream_upsize #(
      .T_DATA_WIDTH(4),
      .T_DATA_RATIO(2)
  ) dut (
      .clk,
      .rst_n(reset),
      .s_data_i,
      .s_last_i,
      .s_valid_i,
      .s_ready_o,
      .m_data_o,
      .m_keep_o,
      .m_last_o,
      .m_valid_o,
      .m_ready_i(1'b1)
  );

  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end

  int i;
  initial begin
    $dumpfile("stream_upsize_tb.fst");
    $dumpvars(0, stream_upsize_tb);
    $readmemb("src/stream_upsize.tv", testvectors);
    for (i = 0; i < 2; i = i + 1) begin
      $dumpvars(0, m_data_o[i]);
    end
    vectornum = 0;
    errors = 0;
    reset = 1;
    #27;
    reset = 0;
  end

  always @(posedge clk) begin
    #1;
    {s_valid_i, s_last_i, s_data_i} = testvectors[vectornum];
  end

  always @(negedge clk)
    if (~reset) begin
      //   if (y !== yexpected) begin
      //     $display("Error: inputs = %b", {a, b, c});
      //     $display(" outputs = %b (%b expected)", y, yexpected);
      //     errors = errors + 1;
      //   end
      vectornum = vectornum + 1;
      if (testvectors[vectornum] === 6'bxxxxxx) begin
        $display("%d tests completed with %d errors", vectornum, errors);
        #50;
        $finish;
      end
    end
endmodule
