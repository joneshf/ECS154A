module transmitter(	input logic clk,
							input logic tf,
							input logic [3:0] framesize,
							input logic [127:0] framebits,
							output logic stuffsend,
							output logic TX);

	// A couple of constants.
	logic startbit = 1'b1;
	logic stopbit = 1'b0;

	// Our counters.
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
	
	// keep track of being enabled.
	logic tfenabled;

	initial begin
		stuffsend = 1'b0;
		tfenabled = 1'b0;
		TX = 1'b0;
		initializer = 1'b1;
	end

	always_ff@(posedge clk) begin
		// Check if we're ready to go, and turn off the TXI if so.
		if(tf) begin
			if(framesize > 4'b0) begin
				tfenabled = 1'b1;
			end
		end

		if(tfenabled) begin
			// Reset everything.
			if(initializer) begin
				// Set the state.
				statemachine = 3'b0;
				// Turn off the initializer.
				initializer = 1'b0;
			end else
			case(statemachine)

				3'b000: begin // Start state.
					// Reset the CRC.
					crcreset = 1'b1;
					// tell the bit stuffer to start taking in data
					stuffsend = 1'b1;
					// Spit out the start bit
					TX = startbit;
					// Time to move to the next state.
					// We reset the framesizeconter
					framesizecounter = 2'b11;
					// Turn off the crc reset.
					crcreset = 1'b0;
					// Set the state.
					statemachine = 3'b001;
				end

				3'b001: begin // Frame counter state.
					// Ensure we're not updating the CRC until necessary.
					crcenable = 1'b1;
					// Set the next bit for the CRC.
					crcin = framesize[framesizecounter];
					// Iterate over each bit in the framesize.
					// Spit out the next bit of `framesize`.
					TX = framesize[framesizecounter];
					// We've spit out the current bit of `framesize`

					// Time to check if we need to move to the next state.
					if(framesizecounter - 1'b1 == 2'b11) begin
						// We use the `{byte,frame}counter`.
						bytecounter = 3'b111;
						framecounter = 4'b0;
						// Set the state.
						statemachine = 3'b010;
					end else begin
						// Stay here but go to the next `framesize` bit.
						framesizecounter = framesizecounter - 1'b1;
					end
				end

				3'b010: begin // Frame data state.
					// Do this `framesize` number of times.
					// Set the next bit for the CRC.
					// Remember, we traverse from MSb to LSb.
					crcin = framebits[(framecounter * 8) + bytecounter];
					// Shit out the next frame data bit.
					TX = framebits[(framecounter * 8) + bytecounter];
					// Check if we've got another byte to go through.
					if(bytecounter == 3'b000) begin
						// We're out of data bits, go to the next state.
						if(framecounter + 1'b1 == framesize) begin
							// We need the `bytecounter`
							bytecounter = 3'b111;
							// Ensure the CRC no longer updates.
							crcenable = 1'b0;
							// Set the state.
							statemachine = 3'b011;
						end else begin
							// Still have another byte of data.
							bytecounter = 3'b111;
							framecounter = framecounter + 1'b1;
						end
					end else begin
						// Time to move on to the next bit.
						bytecounter = bytecounter - 1'b1;
					end
				end

				3'b011: begin // CRC state.
					// Do this for one byte.
					// Spit out the next bit in the CRC.
					TX = crcout[bytecounter];
					
					if(bytecounter == 3'b000) begin
						// Set the next state.
						statemachine = 3'b100;
					end else begin
						// Go to the next bit.
						bytecounter = bytecounter - 1'b1;
					end
				end

				3'b100: begin // Stop state.
					// Just dish out the stop bit
					TX = stopbit;
					// and go to the default state.
					statemachine = 3'b111; // go to default
				end

				default: begin
					TX = 1'b0;
					stuffsend = 1'b0;
					tfenabled = 1'b0;
				end
				
			endcase
		end else begin // else txi
			initializer = 1'b1;
		end
	end

endmodule
