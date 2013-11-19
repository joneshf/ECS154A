module flopen(input logic clk,
				  input logic en,
				  input logic [15:0]d,
				  output logic [15:0]q);
	always_ff@(posedge clk)
		if(en) q<=d;
endmodule