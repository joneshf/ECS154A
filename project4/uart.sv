module uart( // the cpu interface
				input logic [1:0] ADDR, // register address
				input logic NCS, // negative chip select
				input logic NO, // negative read enable
				input logic NW, // negative write enable
				inout logic [7:0] data, // to the cpu
				output logic NINT, // negative interrupt
				 // the serial interface
				input logic RX, // receive
				output logic TX); // transmit
				
endmodule
