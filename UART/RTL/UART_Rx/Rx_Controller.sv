module Rx_Controller (
	input logic clk, reset,
	input start_detected, rx_done, data_valid,
	output logic rx_start, rx_sel, store_en
);

	logic [1:0] c_state, n_state;
	parameter IDLE=2'b00, START=2'b01, RECEIVE=2'b10, STORE=2'b11;

	always_ff @ (posedge clk) begin
	if (reset)
		c_state <= IDLE;
	else
		c_state <= n_state;
	end

	always_comb	begin
		case (c_state)
			IDLE: begin 
				if (start_detected) n_state = START;
				else n_state = IDLE; 
			end
			START: begin 
				n_state = RECEIVE;
			end
			RECEIVE: begin 
				if (rx_done) begin
					if (data_valid) n_state = STORE;
					else n_state = IDLE;
				end
				else n_state = RECEIVE;
			end
			STORE: begin
				n_state = IDLE;
			end
			default: n_state = IDLE;
		endcase
	end

	always_comb begin
		case (c_state)
			IDLE: begin
				rx_start = 1'b0;
				rx_sel = 1'b1;
				store_en = 1'b0;
			end
			START: begin
				rx_start = 1'b1;
				rx_sel = 1'b1;
				store_en = 1'b0;
			end
			RECEIVE: begin
				rx_start = 1'b0;
				rx_sel = 1'b1;
				store_en = 1'b0;
			end
			STORE: begin
				rx_start = 1'b0;
				rx_sel = 1'b0;
				store_en = 1'b1;
			end
		endcase
	end
	
endmodule