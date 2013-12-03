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

		logic [7:0] statin, intin, dataregin, baudin;
		logic [7:0] statout, intout, dataregout, baudout;
		
		//tristate ts(somekindofmuxofregouts, ~NO, DATA);
		
		onefourbusdecode busdmx(DATA, ADDR, ~NCS, statin, intin, dataregin, baudin);
		
		statusregister sr(CLK, statin, statout);
		regoneinterrupt im(CLK, intin, intout);
		regtwodata datareg(CLK, dataregin, dataregout);
		baudratedivisor brd(CLK, baudin, baudout);
		
		interruptlogic il(statout, intout, NINT);
		
endmodule
