module rol_sixteen(	input logic [15:0] a,
							input logic carryin,
							output logic [15:0] b,
							output logic c);
	assign c = a[15];
	assign b = {a[14:0], carryin};
endmodule
