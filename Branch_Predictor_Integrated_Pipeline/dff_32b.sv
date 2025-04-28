module dff_32b (
	input logic clk, reset, [31:0] d,
	output logic [31:0] q
);

always_ff @ (posedge clk)
begin
	if (reset)
		q <= 32'b0;
	else
		q <= d;
end
endmodule