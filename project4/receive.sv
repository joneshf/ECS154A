module receive(input logic clk,
					input logic rx,
					input logic [7:0] baudrate,
					output logic over, dr, fe, nf,
					output logic [7:0] dataout)
	
	logic [127:0] qu;
	logic [7:0] clkcount;  //internal clk count
	
	
					
endmodule