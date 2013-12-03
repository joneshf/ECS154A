module statusregister(	input logic clk,
								input logic wrien,
								input logic [7:0] in,
								output logic [7:0] out);
	/*
	7 - FE / FEC
	6 - CRCE / CRCEC
	5 - OR / ORC
	4 - NF / NFC
	
	3 - TXI
	2 - TBNF
	1 - DR / TF
	0 - ENA
	*/
	always_ff@(posedge clk)
		if(wrien)
			out <= in;
	
endmodule
	