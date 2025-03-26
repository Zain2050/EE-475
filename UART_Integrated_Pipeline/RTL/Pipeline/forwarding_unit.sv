module forwarding_unit (
	input logic [31:0] instruction_e, instruction_w,
	input logic reg_wr_w,
	output logic fwd_A, fwd_B
);
	logic fwd_req;
	logic [4:0] rs1_e, rs2_e, rd_w;
	logic [6:0] opcode_e, opcode_w;
	
	assign rs1_e = instruction_e[19:15];
    assign rs2_e = instruction_e[24:20];
	assign rd_w = instruction_w[11:7];
	assign opcode_e = instruction_e[6:0];
	assign opcode_w = instruction_w[6:0];

	// S-Type and B-Type don't have rd. U-Type and J-Type don't have rs1 and rs2. 
	assign fwd_req = (opcode_w != 7'b0100011) && (opcode_w != 7'b1100011) && (opcode_e != 7'b0110111) && (opcode_e != 7'b1101111);

	always_comb begin
		if (reg_wr_w && fwd_req) begin
			if (rs1_e == rd_w)
				fwd_A = 1'b1;
			else
				fwd_A = 1'b0;
			// I-Types don't have rs2 
			if (rs2_e == rd_w && (opcode_e != 7'b0010011) && (opcode_e != 7'b0000011))
				fwd_B = 1'b1;
			else
				fwd_B = 1'b0;
		end else begin
			fwd_A = 1'b0;
			fwd_B = 1'b0;
		end
	end
endmodule