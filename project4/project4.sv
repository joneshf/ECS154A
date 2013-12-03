module project4( // the cpu interface
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

		logic statin, intin, dataregin, baudin;
		logic [7:0] statout, intout, dataregout, baudout, dataoutput;
		
		tristate ts(dataoutput, ~NO, DATA);
		
		onefourbusdecode 	busdmx(ADDR, ~NCS, statin, intin, dataregin, baudin);
		fouronebusmux 		readbus(statout, intout, dataregout, baudout, ADDR, dataoutput);
		
		statusregister sr(CLK, statin & ~NW, DATA, statout);
		regoneinterrupt im(CLK, intin & ~NW, DATA, intout);
		regtwodata datareg(CLK, dataregin & ~NW, DATA, dataregout);
		baudratedivisor brd(CLK, ~statout[0], baudin & ~NW, DATA, baudout);
		
		interruptlogic il(statout, intout, NINT);
		
endmodule
