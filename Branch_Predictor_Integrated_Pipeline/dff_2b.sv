module dff_2b (
	input logic clk, reset, [1:0] d,
	output logic [1:0] q
);

always_ff @ (posedge clk)
begin
	if (reset)
		q <= 2'b0;
	else
		q <= d;
end
endmodule