module transmitter(	input logic clk,
							input logic tf,
							input logic [3:0] framesize,
							input logic [127:0] framebits,
							input logic [7:0] baudrate,
							output logic TXI,
							output logic TX
							);

	// A couple of constants.
	logic startbit = 1'b1;
	logic stopbit = 1'b0;

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

	// Something to reset the whole game.
	logic initializer;

	initial begin
		TXI = 1'b1;
		TX = 1'b0;
		initializer = 1'b1;
	end

	always_ff@(posedge clk) begin
		// Check if we're ready to go, and turn off the TXI if so.
		if(tf) begin
			if(framesize > 4'b0) begin
				TXI = 1'b0;
			end
		end

		if(~TXI) begin
			// Reset everything.
			if(initializer) begin
				// We use the baudcounter and framecounter in the first state.
				baudcounter = 8'b1;
				// Set the state.
				statemachine = 3'b0;
				// Turn off the initializer.
				initializer = 1'b0;
			end else
			case(statemachine)

				3'b000: begin // Start state.
					// Reset the CRC.
					crcreset = 1'b1;
					// Spit out the start bit `baudrate` times.
					if(baudcounter < baudrate) begin
						TX = startbit;
						baudcounter = baudcounter + 1'b1;
					end
					// Time to move to the next state.
					else begin
						// We reset the framesizeconter and baudcounter.
						framesizecounter = 2'b11;
						baudcounter = 8'b1;
						// Turn off the crc reset.
						crcreset = 1'b0;
						// Set the state.
						statemachine = 3'b001;
					end
				end

				3'b001: begin // Frame counter state.
					// Ensure we're not updating the CRC until necessary.
					crcenable = 1'b0;
					// Set the next bit for the CRC.
					crcin = framesize[framesizecounter];
					// Iterate over each bit in the framesize.
					// Do this `baudrate` times.
					if(baudcounter < baudrate) begin
						// Spit out the next bit of `framesize`.
						TX = framesize[framesizecounter];
						baudcounter = baudcounter + 1'b1;
						// If we're on the last transmit of framesize,
						// update the CRC.
						crcenable = baudcounter == baudrate ? 1'b1 : 1'b0;
					end
					else begin
						// We've spit out the current bit of `framesize`
						// `baudrate` number of times.

						// Time to move to the next state.
						if(framesizecounter - 1'b1 == 2'b11) begin
							// We use the `{baud,byte,frame}counter`.
							baudcounter = 8'b1;
							bytecounter = 3'b111;
							framecounter = 4'b0;
							// Ensure the CRC doesn't update.
							crcenable = 1'b0;
							// Set the state.
							statemachine = 3'b010;
						end
						// Stay here but go to the next `framesize` bit.
						else begin
							baudcounter = 8'b1;
							framesizecounter = framesizecounter - 1'b1;
						end
					end
				end

				3'b010: begin // Frame data state.
					// Do this `framesize` number of times.
					// Ensure the CRC doesn't update.
					crcenable = 1'b0;
					// Set the next bit for the CRC.
					// Remember, we traverse from MSb to LSb.
					crcin = framebits[((15 - framecounter) * 8) + bytecounter];
					// Go through each bit in the next byte.
					// Do this `baudrate` number of times.
					if(baudcounter < baudrate) begin
						// Shit out the next frame data bit.
						TX = framebits[((15 - framecounter) * 8) + bytecounter];
						baudcounter = baudcounter + 1'b1;
						// If we're on the last transmit of framesize,
						// update the CRC.
						crcenable = baudcounter == baudrate ? 1'b1 : 1'b0;
					end
					// We've given out the frame data bit `baudrate`
					// number of times.
					else begin
						// Check if we've got another byte to go through.
						if(bytecounter == 3'b000) begin
							// We're out of data bits, go to the next state.
							if(framecounter + 1'b1 == framesize) begin
								// We need the `{baud,byte}counter`
								baudcounter = 8'b1;
								bytecounter = 3'b111;
								// Ensure the CRC doesn't update.
								crcenable = 1'b0;
								// Set the state.
								statemachine = 3'b011;
							end
							// Still have another byte of data.
							else begin
								// Reset our counters.
								baudcounter = 8'b1;
								bytecounter = 3'b111;
								framecounter = framecounter + 1'b1;
							end
						end
						// Time to move on to the next bit.
						else begin
							baudcounter = 8'b1;
							bytecounter = bytecounter - 1'b1;
						end
					end
				end

				3'b011: begin // CRC state.
					// Do this for one byte.
					// Do this `baudrate` number of times.
					if(baudcounter < baudrate) begin
						// Spit out the next bit in the CRC.
						TX = crcout[bytecounter];
						baudcounter = baudcounter + 1'b1;
					end
					// We've sent a bit `baudrate` times.
					else begin
						// Time to move to the next state.
						if(bytecounter == 3'b000) begin
							// We need the `baudcounter`.
							baudcounter = 8'b1;
							// Set the next state.
							statemachine = 3'b100;
						end
						// More bits!
						else begin
							// Go to the next bit.
							bytecounter = bytecounter - 1'b1;
							baudcounter = 8'b1;
						end
					end
				end

				3'b100: begin // Stop state.
					// Just dish out the stop bit `baudrate` times,
					// Then set the TXI high, and TX low.
					if(baudcounter < baudrate) begin
						TX = stopbit;
						baudcounter = baudcounter + 1'b1;
					end
					else begin
						TX = 1'b0;
						TXI = 1'b1;
					end
				end

				default: TX = 1'b0;
			endcase
		end else begin // else txi
			initializer = 1'b1;
		end
	end

endmodule
