module dff_1b (
	input logic clk, reset, d,
	output logic q
);

always_ff @ (posedge clk)
begin
	if (reset)
		q <= 1'b0;
	else
		q <= d;
end
endmodule