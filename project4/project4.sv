module project4( // the cpu interface
				input logic CLK,
				input logic [1:0] ADDR, // register address
				input logic NCS, // negative chip select
				input logic NO, // negative read enable
				input logic NW, // negative write enable
				inout logic [7:0] DATA, // to the cpu
				output logic NINT, // negative interrupt
				 // the serial interfaces
				input logic RX, // receive
				output logic TX); // transmit

		logic statin, intin, dataregin, baudin;
		logic [7:0] internalstatus, statout, intout, datarxout, baudout, dataoutput;
		logic [3:0] countout;
		logic [127:0] txfifoout;
		
		tristate ts(dataoutput, ~NO, DATA);
		onefourbusdecode 	busdmx(ADDR, ~NCS, statin, intin, dataregin, baudin);
		fouronebusmux 		readbus(statout, intout, datarxout, baudout, ADDR, dataoutput);
		
		statusregister sr(CLK, statin & ~NW, DATA, internalstatus, statout);
		regoneinterrupt im(CLK, intin & ~NW & statout[0], DATA, intout);
		
		transmit txfifo(DATA, dataregin & ~NW & statout[0], statout[1], txfifoout, internalstatus[2], countout);
		baudratedivisor brd(CLK, ~statout[0], baudin & ~NW & ~statout[0], DATA, baudout);
		
		interruptlogic il(statout, intout, NINT);
		
endmodule
