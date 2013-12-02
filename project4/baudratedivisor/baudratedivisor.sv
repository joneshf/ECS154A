module baudratedivisor(	input logic clk,
								input logic [7:0] in,
								input logic notenable,
								output logic [7:0] out);
	/*
	The Baud Rate Divisor is an 8-bit register that is the clock divisor for the serial clock. 
	The Baud Rate Divisor can only be written if the UART is disabled, and must be 5 or 
	larger. Values less than three should not update the Baud Rate Divisor
	*/
	initial
		out = 8'b00000101;

	always_ff@(posedge clk)
		if(notenable & ((in[7] | in[6] | in[5] | in[4] | in[3] | in[2]) | (in[1] & in[0])))
			out <= in;
			
endmodule
