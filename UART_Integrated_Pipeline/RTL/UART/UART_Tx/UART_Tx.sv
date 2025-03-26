module UART_Tx (
    input logic clk, reset,
    input logic [11:0] baud_divisor,
    input logic parity_sel, two_stop_bits, fifo_wr,
    input logic [7:0] fifo_data_in,
    output logic tx_out, txff, txfe
);
    logic [7:0] data;
    logic tx_start, tx_sel, tx_done;

    Tx_FIFO tx_fifo_0 (clk, reset, fifo_data_in, fifo_wr, tx_done, data, txff, txfe);   
    Tx_Datapath datapath_0 (clk, reset, data, baud_divisor, parity_sel, two_stop_bits, tx_start, tx_sel, tx_done, tx_out);
    Tx_Controller controller_0 (clk, reset, ~txfe, tx_done, tx_start, tx_sel);

endmodule