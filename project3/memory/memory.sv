module memory(	input logic [15:0] datain,
					input logic [15:0] addr,
					input logic re, we,
					output logic [15:0] dataout);
	
	// 1k words.
	logic [15:0] words [0:499];
	
	assign dataout = (re && !we) ? words[addr] : 16'bz;
	always
		begin
			if(we && !re)
				words[addr] <= datain;
		end
endmodule
