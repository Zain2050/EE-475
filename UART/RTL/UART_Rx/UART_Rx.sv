module UART_Rx (
    input logic clk, reset,
    input logic [11:0] baud_divisor,
    input logic parity_sel, two_stop_bits, rx_in, fifo_rd,
    output logic [7:0] fifo_data_out,
    output logic rxff, rxfe
);

    logic [7:0] fifo_data_in;
    logic rx_start, rx_sel, rx_done;
    logic data_valid, start_detected;

    Rx_FIFO rx_fifo_0 (clk, reset, fifo_data_in, store_en, fifo_rd, fifo_data_out, rxff, rxfe);   
    Rx_Datapath datapath_0 (clk, reset, rx_in, baud_divisor, parity_sel, two_stop_bits, rx_start, rx_sel, rx_done, start_detected, data_valid, fifo_data_in);
    Rx_Controller controller_0 (clk, reset, start_detected, rx_done, data_valid, rx_start, rx_sel, store_en);

endmodule