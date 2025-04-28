// Author : Muhammad Zain
// Date   : 27/4/2025

module branch_predictor(
	input logic clk, reset,
	input logic [31:0] pc_f, instruction, offset,
	input logic [31:0] pc_e, alu_result_e,
	input logic [1:0] state_e,
	input logic prediction_made_e, jalr_addr_req_e, br_actual,
	input logic prediction_correct,
	output logic [1:0] state_f,
	output logic prediction_made_f, jalr_addr_req_f,
	output logic [31:0] target_pc
);
	
	logic [4:0] bht [127:0];
	logic [13:0] btb [127:0];
	logic [6:0] opcode;
	logic [6:0] index_f, index_e;
	logic [13:0] buffer_entry;
	logic [31:0] addr_from_btb, opposite_dir;
	logic [2:0] tag, mux_sel;
	logic valid, predict_taken;
	logic [1:0] new_state;
	logic is_branch, is_jal, is_jalr;


	assign opcode = instruction[6:0];
	assign index_f = pc_f[8:2];
	assign index_e = pc_e[8:2];

	assign is_branch = (opcode == 7'b1100011);
	assign is_jal = (opcode == 7'b1101111);
	assign is_jalr = (opcode == 7'b1100111);

	assign buffer_entry = (is_jalr) ? btb[index_f] : {9'b0, bht[index_f]};
	assign tag = buffer_entry[2:0];
	assign tag_matched = (tag == pc_f[11:9]);
	assign state_f = (tag_matched) ? buffer_entry[4:3] : 2'b01;
	assign predict_taken = state_f[1];
	assign addr_from_btb = {22'b0, buffer_entry[12:3]} << 2;
	assign valid = buffer_entry[13];
	

	always_comb begin

        if (prediction_made_e & ~prediction_correct) begin			// If branch prediction was wrong
			mux_sel = 3'b011;
			prediction_made_f = 1'b0;
			jalr_addr_req_f = 1'b0;
		end
		else if (jalr_addr_req_e) begin								// If waiting for address from execute stage (jalr)
			mux_sel = 3'b010;
			prediction_made_f = 1'b0;
			jalr_addr_req_f = 1'b0;
		end
		else if (is_jal) begin
			mux_sel = 3'b000;
			prediction_made_f = 1'b0;
			jalr_addr_req_f = 1'b0;
		end
		else if (is_branch) begin
			if (tag_matched & predict_taken)
				mux_sel = 3'b000;
			else
				mux_sel = 3'b100;
			prediction_made_f = 1'b1;
			jalr_addr_req_f = 1'b0;
		end
		else if (is_jalr) begin
			if (tag_matched & valid) begin
				mux_sel = 3'b001;
				jalr_addr_req_f = 1'b0;
			end
			else begin
				mux_sel = 3'b100;
				jalr_addr_req_f = 1'b1;
			end
			prediction_made_f = 1'b0;
		end
		else begin
			mux_sel = 3'b100;
			prediction_made_f = 1'b0;
			jalr_addr_req_f = 1'b0;
		end

		case (mux_sel)
            3'b000: target_pc = pc_f + offset;
            3'b001: target_pc = addr_from_btb;
            3'b010: target_pc = alu_result_e;
            3'b011: target_pc = opposite_dir;
            3'b100: target_pc = pc_f + 4;
        endcase

		// Updating BHT State
		if (state_e == 2'b00)
			new_state = (br_actual) ? 2'b01 : 2'b00;
		else if (state_e == 2'b01)
			new_state = (br_actual) ? 2'b10 : 2'b00;
		else if (state_e == 2'b10)
			new_state = (br_actual) ? 2'b11 : 2'b01;
		else if (state_e == 2'b11)
			new_state = (br_actual) ? 2'b11 : 2'b10;
    end

    always_ff @ (posedge clk)
	begin
		if (reset) begin
			opposite_dir <= 32'b0;
			for (int i = 0; i < 128; i++) begin
                bht[i] <= 5'b01000;			// Weak Not Taken at reset
                btb[i] <= 14'b0;
            end
        end
        else begin
	        if (jalr_addr_req_e)
	        	btb[index_e] <= {1'b1, alu_result_e[11:2], pc_e[11:9]};
	        if (prediction_made_e)
	        	bht[index_e] <= {new_state, pc_e[11:9]};

			if (is_branch) begin	
				if (predict_taken)					// If taken
					opposite_dir <= pc_f + 4;
				else
					opposite_dir <= pc_f + offset;	// If not taken
			end
		end
	end

endmodule