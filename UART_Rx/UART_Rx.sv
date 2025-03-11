module UART_Rx (
    input logic clk, reset,
    input logic [11:0] baud_divisor,
    input logic parity_sel, two_stop_bits, rx_in, fifo_rd,
    output logic tx_out, data_available
);

    logic [7:0] fifo_data_in, fifo_data_out;
    logic rx_start, rx_sel, rx_done;
    logic parity_error, stop_bit_error, start_detected;

    Rx_FIFO rx_fifo_0 (clk, reset, fifo_data_in, store_en, fifo_rd, fifo_data_out, data_available);   
    Rx_DataPath datapath_0 (clk, reset, rx_in, baud_divisor, parity_sel, two_stop_bits, rx_start, rx_sel, rx_done, start_detected, parity_error, stop_bit_error, fifo_data_in);
    Rx_Controller controller_0 (clk, reset, start_detected, rx_done, parity_error, stop_bit_error, rx_start, rx_sel, store_en);

endmodule