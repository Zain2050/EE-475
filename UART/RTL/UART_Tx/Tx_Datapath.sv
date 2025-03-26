module Tx_Datapath (
    input logic clk, reset,
    input logic [7:0] data,
    input logic [11:0] baud_divisor,
    input logic parity_sel, two_stop_bits, tx_start, tx_sel,
    output logic tx_done, tx_out
);

    logic [11:0] shift_reg;
    logic [3:0] packet_size, shift_ctr;
    logic tx_shift_en, parity;

    always_ff @(posedge clk) begin
        if (reset || tx_done) begin
            shift_ctr <= 4'd0;
            shift_reg <= 12'hFFF;
        end
        else if (tx_start) begin
            shift_ctr <= 4'd0;
            shift_reg <= {2'b11, parity, data, 1'b0};
        end
        else if (tx_shift_en && tx_sel) begin            
            shift_reg <= shift_reg >> 1;
            shift_ctr <= shift_ctr + 1;
        end
    end

    assign tx_done = (shift_ctr == packet_size) ? 1'b1 : 1'b0;

    // If parity_sel is 1, it is even else odd
    assign parity = parity_sel ? ~(^data) : (^data);
    assign tx_out = (tx_sel & ~tx_done) ? shift_reg[0] : 1'b1;
    assign packet_size = two_stop_bits ? 4'd12 : 4'd11;

    Tx_Baud_Counter baud_counter_0 (clk, (reset | tx_start), baud_divisor, tx_shift_en);

endmodule