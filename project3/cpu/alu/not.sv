module not_sixteen(	input logic [15:0] a,
							output logic [15:0] b);
	assign b = ~a;
endmodule
