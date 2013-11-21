module fourtoonebusmux(input logic [15:0] d0,d1,d2,d3,
							  input logic s [1:0],
							  output logic [15:0] y);
							  
	logic [15:0] low, high;
	
	twotoonebusmux #(16) lowmux(d0,d1,s[0],low);
	twotoonebusmux #(16) highmux(d2,d3,s[0],high);
	twotoonebusmux #(16) finalmux(low,high,s[1],y);
endmodule
