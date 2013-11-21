module eighttoonebusmux(input logic [15:0]d0,d1,d2,d3,d4,d5,d6,d7,
								input logic [2:0] s,
								output logic [15:0]y);
	
	logic [15:0] low, high;
	
	fourtoonebusmux lowmux(d0,d1,d2,d3,s[1:0],low);
	fourtoonebusmux highmux(d4,d5,d6,d7,s[1:0],high);
	twotoonebusmux #(16) finalmux(low,high,s[2],y);
endmodule
