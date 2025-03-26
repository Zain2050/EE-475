module control_unit_dff(
	input logic clk, reset,
	input logic reg_wr_d, wr_en_d, rd_en_d,
	input logic [1:0] wb_sel_d,
	output logic reg_wr_q, wr_en_q, rd_en_q,
	output logic [1:0] wb_sel_q
);

always_ff @ (posedge clk)
begin
	if (reset) begin
		reg_wr_q <= 1'b0;
		wr_en_q <= 1'b0;
		rd_en_q <= 1'b0;
		wb_sel_q <= 2'b0;
	end
	else begin
		reg_wr_q <= reg_wr_d;
		wr_en_q <= wr_en_d;
		rd_en_q <= rd_en_d;
		wb_sel_q <= wb_sel_d;
	end
end
endmodule