module memory(	input logic [15:0] datain,
					input logic [15:0] addr,
					input logic re, we, clk,
					output logic [15:0] dataout);

	// 1k words.
	logic [15:0] words [0:499];

	initial begin

		words[1]  = 16'b1000000000000010;
		words[2]  = 16'b1000100000000000;
		words[3]  = 16'b0001000100000011;
		words[4]  = 16'b1000011100010101;
		words[5]  = 16'b1000111100000000;
		words[6]  = 16'b1001100111100001;
		words[7]  = 16'b0000101000000100;
		words[8]  = 16'b1001001111100001;
		words[9]  = 16'b0101010001000000;
		words[10] = 16'b0100010101100000;
		words[11] = 16'b1000011000000100;
		words[12] = 16'b1101011000000000;
		words[13] = 16'b1000000000000000;
		words[14] = 16'b1000100000000000;
		words[15] = 16'b1000011000010101;
		words[16] = 16'b1000111000000000;
		words[17] = 16'b1010100000000011;
		words[18] = 16'b0011111100100000;
		words[19] = 16'b1011011000000000;
		words[20] = 16'b0010111100100000;
		words[21] = 16'b1111100000000000;
	end

	assign dataout = (re && !we) ? words[addr] : 16'bz;

	always@(posedge clk) begin
		if(we && !re)
			words[addr] <= datain;
	end
endmodule
