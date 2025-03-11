module UART_Tx (
    input logic clk, reset,
    input logic [7:0] fifo_data_in,
    input logic [11:0] baud_divisor,
    input logic parity_sel, two_stop_bits, fifo_wr,
    output logic tx_out
);
    logic [7:0] data_in, data;
    logic tx_start, tx_sel, tx_done;
    logic data_available;

    Tx_FIFO tx_fifo_0 (clk, reset, fifo_data_in, fifo_wr, tx_done, data, data_available);   
    Tx_DataPath datapath_0 (clk, reset, data, baud_divisor, parity_sel, two_stop_bits, tx_start, tx_sel, tx_done, tx_out);
    Tx_Controller controller_0 (clk, reset, data_available, tx_done, tx_start, tx_sel);

endmodule