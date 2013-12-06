module receiver(input logic clk,
					input logic RX,
					input logic [7:0] baudrate,
					output logic dr, nf, over, fe,
					output logic [7:0] dataout);

	logic [127:0] framedata;  			//the data in the frame
	logic [7:0] framecrc;				//i don't know what this is
	logic [3:0] framesize;				//how big each frame should be
	logic [3:0] statemachine = 3'b0;
	logic [7:0] baudcounter = 8'b0;  	//internal clk count
	logic [7:0] ones, zeros;
	logic [1:0] fsincrement = 2'b0;		//increments through framesize (3..0) to input RX bits
	logic [1:0] fscounter = 2'b0;			//counter to increment RX
	logic [2:0] byteincrement = 3'b0;	//increments through byte0 (7..0) to input RX bits
	logic [2:0] bytecounter = 3'b0;		//counter to increment RX
	logic moreofbit;

	// Our counters.
	logic [7:0] baudcounter = 8'b1;
	logic [3:0] framecounter;
	logic [2:0] bytecounter, statemachine;
	logic [1:0] framesizecounter;

	// CRC stuff.
	logic crcenable, crcreset = 1'b0;
	logic crcin;
	logic [7:0] crcout;
	crc crccalc(crcenable, clk, crcreset, crcin, crcout);

	initial begin
		nf = 1'b0;
		dr = 1'b0;
	end

	always_ff@(posedge clk) begin
		//noise flag logic
		//go through the if statement baudrate times
		if(baudcounter < baudrate) begin
			//increment zeros if RX = 0
			if(RX == 1'b0)
				zeros = zeros + 1'b1;
			//increment ones if RX = 1
			else
				ones = ones + 1'b1;
			baudcounter = baudcounter + 1'b1;
		end

		//if there are more ones than zeros we have more ones
		if(zeros < ones) begin
			moreofbit = 1'b1;
			//if two clk times are measured with a diff. value than the moreofbit
			if(zeros > 2'b10)
				//noise flag is set to one
				nf = 1'b1;
		end
		// More ones than zeros.
		else if(ones < zeros)
		begin
			moreofbit = 1'b0;
			//if two clk times are measured with a diff. value than the moreofbit
			if(ones > 2'b10)
				//noise flag is set to one
				nf = 1'b1;
		end
		//end noise flag logic

		case(statemachine)
			3'b000: begin // State state.
				// Reset the CRC.
				crcreset = 1'b1;
				// Take in the start bit `baudrate` times.
				if(baudcounter < baudrate) begin
					//we only begin if the start bit is one and it isn't noise, otherwise ignore
					if(RX == 1'b1 & nf == 0)begin
						baudcounter = baudcounter + 1'b1;
					end
				end
				// Time to move to the next state.
				else
					statemachine = 3'b001;
			end
			3'b001: begin
				//bits 1-4 are frame size
				//this is kind of right except it needs to also account for the clock so RX will send in the next bit
				framesize = 4'b0;
				if(fsincrement != 2'b11) begin
					framesize[3] = RX;
					//here the RX needs to update to the next bit
					framesize[2] = RX;
					//the RX needs to update again
					framesize[1] = RX;
					//the RX needs to update again
					framesize[0] = RX;
					fsincrement = fsincrement + 1'b1;
				end
				statemachine = statemachine + 1'b1;
			end
			3'b010: begin
				//first data byte
				if(byteincrement != 3'b111)begin
					framedata[7] = RX;
					//RX needs to update
					framedata[6] = RX;
					//RX needs to update
					framedata[5] = RX;
					//RX needs to update
					framedata[4] = RX;
					//RX needs to update
					framedata[3] = RX;
					//RX needs to update
					framedata[2] = RX;
					//RX needs to update
					framedata[1] = RX;
					//RX needs to update
					framedata[0] = RX;
					byteincrement = byteincrement + 1'b1;
				end
				statemachine = statemachine + 1'b1;
			end
			3'b011: begin
				//fill up the rest of the framedata
				//first check to see if there is too much data and set OR if there is
				//(it can still fill up to the end of framedata)
				if((framesize * 3'b111) > 7'b1111111)  //if the amount of bits to be input into framedata is larger than 127 (index 0)
				begin
					over = 1'b1;
				end
				//else
				//begin
				//follow the above template for the last two states
				//the difference is, each byte is MSB to LSB, so 15..8, 23..16, and so on
				//also, i recommend using logic if the over bit is 1 (put bits up to 127 in and stop)
				//if the over bit hasn't been set, this else statement would figure out how many RX bits go into framedata
				//remember that the first byte has already been input, so it would start at 15..8 and then go to FS*8-1..FS*7


			end
			3'b100: begin
				//this is for CRC
				//have to check for crc error by comparing the values from the crc RX bits
				//to the calculated crc

			end
			3'b101: begin
				//this is for the stop bit
				//fe gets set if the stop bit is one or if there are missing stuff bits

			end
		endcase

	end



endmodule
