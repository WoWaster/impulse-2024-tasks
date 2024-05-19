module stream_upsize #(
    parameter int unsigned T_DATA_WIDTH = 1,
    parameter int unsigned T_DATA_RATIO = 2
) (
    input logic clk,
    input logic rst_n,
    input logic [T_DATA_WIDTH-1:0] s_data_i,
    input logic s_last_i,
    input logic s_valid_i,
    output logic s_ready_o,
    output logic [T_DATA_WIDTH-1:0] m_data_o[T_DATA_RATIO],
    output logic [T_DATA_RATIO-1:0] m_keep_o,
    output logic m_last_o,
    output logic m_valid_o,
    input logic m_ready_i
);

  logic [T_DATA_RATIO-1:0] counter;
  logic [T_DATA_WIDTH-1:0] data_t[T_DATA_RATIO];
  logic [T_DATA_RATIO-1:0] keep_t;
  int i;

  always_ff @(posedge clk, posedge rst_n) begin
    if (rst_n) begin
      counter   <= 'b0;
      s_ready_o <= 1'b1;
      for (i = 0; i < T_DATA_RATIO; i = i + 1) begin
        m_data_o[i] <= 'b0;
      end
      m_keep_o  <= 'b0;
      m_last_o  <= 1'b0;
      m_valid_o <= 1'b0;
    end else begin
      if (~m_ready_i) s_ready_o <= 1'b0;
      else if (~s_ready_o) begin
        s_ready_o <= 1'b1;
        m_valid_o <= 1'b1;
        m_last_o  <= 1'b1;
      end else if (m_valid_o) begin
        counter   <= 'b0;
        s_ready_o <= 1'b1;
        for (i = 0; i < T_DATA_RATIO; i = i + 1) begin
          m_data_o[i] <= 'b0;
        end
        m_keep_o  <= 'b0;
        m_last_o  <= 1'b0;
        m_valid_o <= 1'b0;
      end else if (s_valid_i) begin
        data_t[counter] <= s_data_i;
        keep_t[counter] <= 1'b1;
        if (counter == (T_DATA_RATIO - 1)) begin
          counter <= 'b0;
          keep_t  <= 'b0;
          for (i = 0; i < T_DATA_RATIO; i = i + 1) begin
            data_t[i] <= 'b0;
          end

          m_valid_o <= 1'b1;
          for (i = 0; i < T_DATA_RATIO; i = i + 1) begin
            m_data_o[i] <= data_t[i];
          end
          // m_data_o  <= data_t;
          m_keep_o <= keep_t;
        end else if ((counter != (T_DATA_RATIO - 1)) && s_last_i) begin
          counter   <= 'b0;
          s_ready_o <= 1'b0;
        end else counter += 1;


        // m_data_o[counter] <= s_data_i;
        // m_keep_o[counter] <= 1'b1;
        // if (counter == (T_DATA_RATIO - 1)) begin
        //   counter   <= 'b0;
        //   m_valid_o <= 1'b1;
        // end else if ((counter != (T_DATA_RATIO - 1)) && s_last_i) begin
        //   counter   <= 'b0;
        //   s_ready_o <= 1'b0;
        // end else counter += 1;
      end
    end
  end

endmodule
