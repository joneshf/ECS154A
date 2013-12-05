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
		if(wrien) begin
			if(~in[0])
				out <= 8'b0;
			else if(in[0])
				out <= 1'b1;
			else if(in[7])
				out[7] <= 1'b0;
			else if(in[6])
				out[6] <= 1'b0;
			else if(in[5])
				out[5] <= 1'b0;
			else if(in[4])
				out[4] <= 1'b0;
		end

		if(internalin[7])
			out[7] <= 1'b1;
		if(internalin[6])
			out[6] <= 1'b1;
		if(internalin[5])
			out[5] <= 1'b1;
		if(internalin[4])
			out[4] <= 1'b1;
		if(internalin[3])
			out[3] <= 1'b1;
		
		// these two need to be able to zero
		if(internalin[2] == 1'b1)
			out[2] <= 1'b1;
		else
			out[2] <= 1'b0;
			
		if(internalin[1])
			out[1] <= 1'b1;
		else
			out[1] <= 1'b0;
	end
endmodule
	