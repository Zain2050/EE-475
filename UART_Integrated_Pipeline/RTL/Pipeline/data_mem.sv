module data_mem(
	input logic clk, wr_en, rd_en,
	input logic [31:0] addr, wdata,
	output logic [31:0] rdata,
	input logic [31:0] uart_status, uart_rx_fifo_data,
	output logic [31:0] uart_control, uart_tx_dr
);
	
	logic [31:0] memory [1023:0];
	
	always_ff @(negedge clk) begin
		if (wr_en)
			memory[addr] <= wdata;

		memory[1023] <= uart_status;
		memory[1021] <= uart_rx_fifo_data;	
	end

	assign rdata = (rd_en) ? memory[addr] : 32'b0;
	
	assign uart_control = memory[1022];
	assign uart_tx_dr = memory[1020];

endmodule