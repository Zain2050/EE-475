module Tx_Controller (
	input logic clk, reset,
	input data_available, tx_done,
	output logic tx_start, tx_sel
);

	logic [1:0] c_state, n_state;
	parameter IDLE=2'b00, LOAD=2'b01, TRANSMIT=2'b10;

	always_ff @ (posedge clk) begin
	if (reset)
		c_state <= IDLE;
	else
		c_state <= n_state;
	end

	always_comb	begin
		case (c_state)
			IDLE: begin 
				if (data_available) n_state = LOAD;
				else n_state = IDLE; 
			end
			LOAD: begin 
				n_state = TRANSMIT;
			end
			TRANSMIT: begin 
				if (tx_done) n_state = IDLE;
				else n_state = TRANSMIT;
			end
			default: n_state = IDLE;
		endcase
	end

	always_comb begin
		case (c_state)
			IDLE: begin
				tx_start = 1'b0;
				tx_sel = 1'b0;
			end
			LOAD: begin
				tx_start = 1'b1;
				tx_sel = 1'b0;
			end
			TRANSMIT: begin
				tx_start = 1'b0;
				tx_sel = 1'b1;
			end
		endcase
	end
	
endmodule