module Rx_Datapath (
    input logic clk, reset,
    input logic rx_in,
    input logic [11:0] baud_divisor,
    input logic parity_sel, two_stop_bits, rx_start, rx_sel,
    output logic rx_done, start_detected, parity_error, stop_bit_error,
    output logic [7:0] data_out
);

    logic [11:0] shift_reg;
    logic [3:0] packet_size, shift_ctr;
    logic rx, rx_shift_en, parity;

    always_ff @(posedge clk) begin
        if (reset || rx_start) begin
            shift_ctr <= packet_size;
            rx_done <= 1'b0;
        end
        else if (rx_shift_en) begin
            if (shift_ctr == 3'b0)
                rx_done <= 1'b1;
            else begin
                shift_reg[shift_ctr] <= rx;
                shift_reg <= shift_reg >> 1;
                shift_ctr <= shift_ctr - 1;
                rx_done <= 1'b0;
            end
        end
    end


    // If parity_sel is 1, it is even else odd
    assign parity = parity_sel ? ~(^shift_reg[8:1]) : (^shift_reg[8:1]);
    assign parity_error = (parity == shift_reg[9]) ? 1'b0 : 1'b1;
    assign stop_bit_error = two_stop_bits ? ~(shift_reg[10] & shift_reg[11]) : ~shift_reg[10];


    assign rx = rx_sel ? rx_in : 1'b1;
    assign start_detected = rx ? 1'b0 : 1'b1;
    assign packet_size = two_stop_bits ? 4'd12 : 4'd11;

    Rx_Baud_Counter baud_counter_0 (clk, (reset | rx_start), baud_divisor, rx_shift_en);

endmodule