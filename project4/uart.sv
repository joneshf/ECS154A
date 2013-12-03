module uart( // the cpu interface
				input logic CLK,
				input logic [1:0] ADDR, // register address
				input logic NCS, // negative chip select
				input logic NO, // negative read enable
				input logic NW, // negative write enable
				inout logic [7:0] DATA, // to the cpu
				output logic NINT, // negative interrupt
				 // the serial interface
				input logic RX, // receive
				output logic TX); // transmit
				
	/*
		registers:
		0 - status / command register
			set by cpu through the data bus. But some conditions
			within the module will cause status flags to change.

		1 - interrupt mask register
			set by the cpu. these flags can be directly compared with 
			the status flags, and the output will be interrupt out.

		2 - data register
			the data to send to the cpu or the data coming from cpu

		3 - baud rate divisor register
			the amount to divide the clock by, to hold the RX or TX 
			for each bit, for this number of clocks.
	*/
	
	/*
		submodules:
		crc - calculate the checksum of incoming or outgoing data
		.... more?
	*/
		
endmodule
