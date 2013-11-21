module add_sixteen(	input logic [15:0] a, b,
							input logic carryin,
							output logic [15:0] s, // sum
							output logic c, o); // carry, overflow

	logic [2:0] ci; // carry between the four groups
	
	add_four e(a[3:0], b[3:0], carryin, s[3:0], ci[0]);
	add_four f(a[7:4], b[7:4], ci[0], s[7:4], ci[1]);
	add_four g(a[11:8], b[11:8], ci[1], s[11:8], ci[2]);
	add_four h(a[15:12], b[15:12], ci[2], s[15:12], c);
	
	assign o = ci[2] ^ c;
endmodule
