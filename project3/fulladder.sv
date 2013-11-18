module fulladder(	input logic carryin, a, b,
						output logic s/*, carryout*/);
	logic p, g;
	always_comb
		begin
			p = a ^ b;
			// g = a & b;
			s = p ^ carryin;
			// carryout = g | (p & carryin);
		end
endmodule
