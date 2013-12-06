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
				output logic TX);

		logic statin, intin, dataregin, baudin;
		logic [7:0] internalstatus, statout, intout, datarxout, baudout, dataoutput;
		logic [3:0] countout, countin;
		logic [127:0] txfifoout;
		logic [7:0] eightbitthing;
		logic txout, stuffsend;
		
		logic TF, intwrite, txfifowrite, baudwrite;

		assign TF = statin & DATA[1] & statout[0] & ~NW;
		assign intwrite = intin & ~NW & statout[0];
		assign txfifowrite = dataregin & ~NW & statout[0];
		assign baudwrite = baudin & ~NW & ~statout[0];

		always@(posedge TF) begin
			countin = countout;
		end

		tristate ts(dataoutput, ~NO, DATA);

		onefourbusdecode 	busdmx(ADDR, ~NCS, statin, intin, dataregin, baudin);
		fouronebusmux 		readbus(statout, intout, datarxout, baudout, ADDR, dataoutput);

		statusregister sr(CLK, statin & ~NW, DATA, internalstatus, statout);
		regoneinterrupt im(CLK, intwrite, DATA, intout);

		transmit txfifo(CLK, DATA, txfifowrite, TF, txfifoout, internalstatus[2], countout);
		baudratedivisor brd(CLK, ~statout[0], baudwrite, DATA, baudout);

		interruptlogic il(statout, intout, NINT);

		transmitter transx(CLK, TF, countin, txfifoout, stuffsend, txout);
		stuffer stuffon(CLK, stuffsend, txout, baudout, internalstatus[3], TX);

		receive rxbandits(CLK, RX, baudout, internalstatus[1], internalstatus[4], internalstatus[5], internalstatus[6], internalstatus[7], eightbitthing);

endmodule
