module shr_sixteen(	input logic [15:0] a,
							output logic [15:0] b,
							output logic c);
	assign c = a[0];
	assign b = {a[15], a[15:1]};
endmodule
