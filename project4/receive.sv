module receive(input logic clk,
					input logic RX,
					input logic [7:0] baudrate,
					output logic dr, nf, /*over, fe,*/
					// output logic [7:0] dataout,

	output logic [127:0] framedata,  			//the data in the frame
	output logic [3:0] framecounter,
	output logic [3:0] framesize,				//how big each frame should be
	output logic [3:0] statemachine = 3'b0,
	output logic [7:0] baudcounter = 8'b0,  	//internal clk count
	output logic [7:0] ones, zeros,
	// output logic [1:0] fsincrement = 2'b0,		//increments through framesize (3..0) to input RX bits
	output logic [1:0] fscounter = 2'b0,			//counter to increment RX
	// output logic [2:0] byteincrement = 3'b0,	//increments through byte0 (7..0) to input RX bits
	output logic [2:0] bytecounter = 3'b111,		//counter to increment RX
	output logic moreofbit, resetmoreofbit,

	// Our counters.
	// output logic [3:0] framecounter,

	// CRC stuff.
	output logic crcenable, crcreset = 1'b0,
	output logic crcin,
	output logic [7:0] crcout
	);
	crc crccalc(crcenable, clk, crcreset, crcin, crcout);

	initial begin
		nf = 1'b0;
		dr = 1'b0;
		statemachine = 3'b000;
	end

	always_ff@(posedge clk) begin
		//noise flag logic
		//go through the if statement baudrate times
		if(baudcounter <= baudrate) begin
			//increment zeros if RX = 0
			if(RX == 1'b0)
				zeros = zeros + 1'b1;
			//increment ones if RX = 1
			else
				ones = ones + 1'b1;
			baudcounter = baudcounter + 1'b1;
		end
		if (resetmoreofbit) begin
			zeros = 1'b0;
			ones = 1'b0;
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
		else if(ones < zeros) begin
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
				// Time to move to the next state.
				if (baudcounter == baudrate + 1 & moreofbit == 1'b1 & ~nf) begin
					// We need the `fscounter` and `baudcounter`.
					fscounter = 2'b11;
					baudcounter = 8'b0;
					// Turn off the CRC reset.
					crcreset = 1'b0;
					// Reset the `moreofbit`.
					resetmoreofbit = 1'b1;
					// Set the next state.
					statemachine = 3'b001;
				end
			end
			3'b001: begin // Frame size state.
				//bits 1-4 are frame size

				// Stop resetting the `moreofbit`
				resetmoreofbit = 1'b0;
				// Ensure we're not updating the CRC until necessary.
				crcenable = 1'b0;
				// Time to go to the next bit.
				if (baudcounter == baudrate & ~nf) begin
					// Set the next bit for the CRC.
					crcin = moreofbit;
					// Calculate the next CRC.
					crcenable = 1'b1;
					// Set the bit in the `framesize`.
					framesize[fscounter] = moreofbit;
					// Reset the `moreofbit`.
					resetmoreofbit = 1'b1;
					// Reset the `baudcounter`.
					baudcounter = 8'b0;

					// Have more bits to check.
					if (fscounter > 1'b0) begin
						// Move to the next bit in the `framesize`.
						fscounter = fscounter - 1'b1;
					end
					// Move to the next state.
					else begin
						// Set the state.
						statemachine = 3'b010;
						// We need the `{byte,frame}counter`.
						bytecounter = 3'b111;
						framecounter = 4'b0;
					end

				end
			end
			3'b010: begin // Frame data state.
				// Stop resetting the `moreofbit`
				resetmoreofbit = 1'b0;
				// Ensure we're not updating the CRC until necessary.
				crcenable = 1'b0;
				// Time to go to the next bit.
				if (baudcounter == baudrate & ~nf) begin
					// Set the next bit for the CRC.
					crcin = moreofbit;
					// Calculate the next CRC.
					crcenable = 1'b1;
					// Set the framedata, it's MSb first.
					framedata[((15 - framecounter) * 8) + bytecounter] = moreofbit;
					// Reset the `moreofbit`.
					resetmoreofbit = 1'b1;
					// Reset the `baudcounter`.
					baudcounter = 8'b0;

					// We have no more bits in this byte
					if (bytecounter == 3'b0) begin
						// Still have another byte of data to receive.
						if (framecounter < framesize) begin
							// Increment the `framecounter`.
							framecounter += 1'b1;
						end
						// Time to move on with our lives.
						else begin
							statemachine = 3'b011;
						end
					end
					// Time to move to the next bit.
					else
						bytecounter -= 1'b1;
				end
			end
			// 	//first data byte
			// 	if(byteincrement != 3'b111)begin
			// 		framedata[7] = RX;
			// 		//RX needs to update
			// 		framedata[6] = RX;
			// 		//RX needs to update
			// 		framedata[5] = RX;
			// 		//RX needs to update
			// 		framedata[4] = RX;
			// 		//RX needs to update
			// 		framedata[3] = RX;
			// 		//RX needs to update
			// 		framedata[2] = RX;
			// 		//RX needs to update
			// 		framedata[1] = RX;
			// 		//RX needs to update
			// 		framedata[0] = RX;
			// 		byteincrement = byteincrement + 1'b1;
			// 	end
			// 	statemachine = statemachine + 1'b1;
			// end
			// 3'b011: begin
			// 	//fill up the rest of the framedata
			// 	//first check to see if there is too much data and set OR if there is
			// 	//(it can still fill up to the end of framedata)
			// 	if((framesize * 3'b111) > 7'b1111111)  //if the amount of bits to be input into framedata is larger than 127 (index 0)
			// 	begin
			// 		over = 1'b1;
			// 	end
			// 	//else
			// 	//begin
			// 	//follow the above template for the last two states
			// 	//the difference is, each byte is MSB to LSB, so 15..8, 23..16, and so on
			// 	//also, i recommend using logic if the over bit is 1 (put bits up to 127 in and stop)
			// 	//if the over bit hasn't been set, this else statement would figure out how many RX bits go into framedata
			// 	//remember that the first byte has already been input, so it would start at 15..8 and then go to FS*8-1..FS*7


			// end
			// 3'b100: begin
			// 	//this is for CRC
			// 	//have to check for crc error by comparing the values from the crc RX bits
			// 	//to the calculated crc

			// end
			// 3'b101: begin
			// 	//this is for the stop bit
			// 	//fe gets set if the stop bit is one or if there are missing stuff bits

			// end
		endcase

	end

endmodule
