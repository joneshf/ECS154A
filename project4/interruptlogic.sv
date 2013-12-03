module interruptlogic(input logic [7:0] statout,
							 input logic [7:0] intout,
							 output logic result);
							 
	assign result = (statout[0] & intout [0]) |~ 
						 (statout[1] & intout [1]) |~
						 (statout[2] & intout [2]) |~
						 (statout[3] & intout [3]) |~
						 (statout[4] & intout [4]) |~
						 (statout[5] & intout [5]) |~
						 (statout[6] & intout [6]) |~
						 (statout[7] & intout [7]);					 
endmodule