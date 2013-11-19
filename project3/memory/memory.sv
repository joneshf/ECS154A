module memory(	input logic [15:0] datain,
					input logic [15:0] addr,
					input logic re, we,
					output logic [15:0] dataout);
	
	// 1k words.
	logic [15:0] words [0:499];
	
	assign dataout = (re) ? words[addr] : 16'bz;
	
	// if we then deref addr and set words to data.
	// if re then data gets words @ addr
	
	// THE PROBLEM here is that reads are returning unknown
	always
			if(we)
				words[addr] <= datain;
endmodule
