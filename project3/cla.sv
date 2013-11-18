module carry_lookahead_four(	input logic [3:0] a, b,
										input logic c,
										output logic [3:1] ci, // internal carry bits
										output logic cout); // carryout
	// c_i+1 = g_i | (p_i & c_i)
	// propagate: p = a | b
	// generate: g = a & b
	assign ci[1] = (a[0] & b[0]) | ((a[0] | b[0]) & c);
	assign ci[2] = (a[1] & b[1]) | ((a[1] | b[1]) & ci[1]);
	assign ci[3] = (a[2] & b[2]) | ((a[2] | b[2]) & ci[2]);
	assign cout = (a[3] & b[3]) | ((a[3] | b[3]) & ci[3]);
endmodule
