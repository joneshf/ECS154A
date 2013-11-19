module sign_extension(	input logic [4:0] value,
								output logic [15:0] extension);
	assign extension = {{11{value[4]}}, value[4:0]};
endmodule
