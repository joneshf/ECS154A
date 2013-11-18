module ror_sixteen(	input logic [15:0] a,
							input logic carryin,
							output logic [15:0] b,
							output logic c);
	// c is carry out. LSB is rotated to c, 
	// carryin should be taken from carry flag???
	// and rotated to MSB.
	assign c = a[0];
	assign b = {carryin, a[15:1]};
endmodule
