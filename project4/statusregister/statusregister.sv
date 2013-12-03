module statusregister(	input logic clk,
								input logic wrien,
								input logic [7:0] in,
								input logic [7:0] internalin,
								output logic [7:0] out);
	/*
	7 - FE / FEC
	6 - CRCE / CRCEC
	5 - OR / ORC
	4 - NF / NFC
	
	3 - TXI
	2 - TBNF
	1 - DR / TF
	0 - ENA / ENA
	*/
	always_ff@(posedge clk) begin
		out <= internalin;
		if(wrien)
			if(~in[0])
				out <= 8'b0;
			else if(in[7])
				out[7] <= 1'b0;
			else if(in[6])
				out[6] <= 1'b0;
			else if(in[5])
				out[5] <= 1'b0;
			else if(in[4])
				out[4] <= 1'b0;
	end
endmodule
	