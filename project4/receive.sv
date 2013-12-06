module receive(input logic clk,
					input logic RX,
					input logic [7:0] baudrate,
					output logic dr, nf, over, crce, fe,
					output logic [7:0] dataout
	);

	logic [127:0] framedata;  			//the data in the frame
	logic [3:0] statemachine = 3'b0;

	// Our counters.
	logic [7:0] baudcounter = 8'b0;  	//internal clk count
	logic [3:0] framecounter;
	logic [3:0] framesize;				//how big the data frame should be
	logic [2:0] bytecounter = 3'b111;
	logic [1:0] fscounter = 2'b0;

	// Noise checking.
	logic [7:0] ones, zeros;
	logic moreofbit, resetmoreofbit;

	// CRC stuff.
	logic crcenable, crcreset = 1'b0;
	logic crcin;
	logic [7:0] crcout;
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
						if (framecounter + 1 < framesize) begin
							// Increment the `framecounter`.
							framecounter += 1'b1;
						end
						// Time to move on with our lives.
						else begin
							// We need the bytecounter.
							bytecounter = 3'b111;
							// Clear the crce.
							crce = 1'b0;
							// Set the state.
							statemachine = 3'b011;
						end
					end
					// Time to move to the next bit.
					else
						bytecounter -= 1'b1;
				end
			end
			3'b011: begin // CRC state.
				// Stop resetting the `moreofbit`
				resetmoreofbit = 1'b0;
				// Ensure we're not updating the CRC at all.
				crcenable = 1'b0;
				// Time to go to the next bit.
				if (baudcounter == baudrate & ~nf) begin
					// Check that the current bit is accurate for the CRC generated.
					crce |= crcout[bytecounter] != moreofbit;
					// Reset the `moreofbit`.
					resetmoreofbit = 1'b1;
					// Reset the `baudcounter`.
					baudcounter = 8'b0;

					// We have no more CRC bits.
					if (bytecounter == 3'b0) begin
						// Go on to the next state.
						statemachine = 3'b100;
					end
					// More bits to check.
					else begin
						bytecounter -= 1'b1;
					end
				end
			end
			3'b100: begin // Stop state.
				// Stop resetting the `moreofbit`
				resetmoreofbit = 1'b0;
				// Let's check this stop bit.
				if (baudcounter == baudrate & ~nf) begin
					// fe gets set if the stop bit is one.
					fe = moreofbit;
				end
			end
		endcase

	end

endmodule
