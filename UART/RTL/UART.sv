module uart (
	input logic clk, reset,
	input logic [14:0] uart_control,
    input logic tx_fifo_wr, rx_fifo_rd,
    input logic [7:0] tx_fifo_data_in,
    input logic rx_in,
    output logic tx_out,
    output logic [7:0] rx_fifo_data_out,
    output logic [3:0] uart_status
);
	
	logic [11:0] baud_divisor;
	logic parity_sel, two_stop_bits, loopback, rx_input;
	logic txff, txfe, rxff, rxfe;
	
	assign uart_status = {txff, txfe, rxff, rxfe};
	assign baud_divisor = uart_control[11:0];
	assign parity_sel = uart_control[12];
	assign two_stop_bits = uart_control[13];
	assign loopback = uart_control[14];
	assign rx_input = (loopback ? tx_out : rx_in);

	UART_Tx uart_tx_0 (clk, reset, baud_divisor, parity_sel, two_stop_bits, tx_fifo_wr, tx_fifo_data_in, tx_out, txff, txfe);
	UART_Rx uart_rx_0 (clk, reset, baud_divisor, parity_sel, two_stop_bits, rx_input, rx_fifo_rd, rx_fifo_data_out, rxff, rxfe);

endmodule