module add_four(	input logic [3:0] a, b,
						input logic carryin,
						output logic [3:0] c,
						output logic carryout);
	// so we declare full adders for each of the bits in this four,
	// and we will define the carry in for each one as it is declared.
	logic [3:1] ci; // ith carry bit
	carry_lookahead_four cla(a, b, carryin, ci, carryout);
	
	fulladder e(carryin, a[0], b[0], c[0]);
	fulladder f(ci[1], a[1], b[1], c[1]);
	fulladder g(ci[2], a[2], b[2], c[2]);
	fulladder h(ci[3], a[3], b[3], c[3]);
endmodule
	