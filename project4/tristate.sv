module tristate(input logic [7:0] a,
					 input logic 		 en,
					 output tri  [7:0] y);
	assign y = en ? a : 4'bz;
endmodule