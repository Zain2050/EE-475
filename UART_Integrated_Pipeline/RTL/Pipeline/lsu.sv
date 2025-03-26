module lsu(
	input logic clk, wr_en, rd_en,
	input logic [31:0] addr, wdata,
	output logic [31:0] rdata,

	// UART Signals
	output logic [14:0] uart_control,
	output logic tx_fifo_wr, rx_fifo_rd,
    output logic [7:0] tx_fifo_data_in,
	input logic [7:0] rx_fifo_data_out,
    input logic [3:0] uart_status
);

	logic [31:0] uart_tx_dr, uart_ctrl;

	assign tx_fifo_data_in = uart_tx_dr[7:0];
	assign uart_control = uart_ctrl[14:0];

	// If writing to uart_tx_dr, send a signal to the tx FIFO
	assign tx_fifo_wr = (addr == 12'd1020 && wr_en) ? 1'b1 : 1'b0;
	// If reading from uart_rx_dr, send a signal to the rx FIFO
	assign rx_fifo_rd = (addr == 12'd1021 && rd_en) ? 1'b1 : 1'b0;

	data_mem data_mem_0 (clk, wr_en, rd_en, addr, wdata, rdata, {28'b0, uart_status}, {24'b0, rx_fifo_data_out}, uart_ctrl, uart_tx_dr);

endmodule