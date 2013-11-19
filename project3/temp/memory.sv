module memory(	inout logic [15:0] data,
					input logic [15:0] addr,
					input logic re, we);
	
	// 1k words.
	logic [15:0] words [0:999];
	
	assign data = (re) ? words[addr] : 16'bz;
	
	// if we then deref addr and set words to data.
	// if re then data gets words @ addr
	
	// THE PROBLEM here is that reads are returning unknown
	always_latch
			if(we)
				words[addr] <= data;
endmodule
