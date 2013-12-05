module transmitter(	input logic clk,
							input logic tf,
							input logic [3:0] framesize,
							input logic [127:0] framebits,
							input logic [7:0] baudrate,
							output logic TXI,
							output logic TX);

	logic startbit = 1'b1;
	logic stopbit = 1'b0;
	logic [7:0] baudcounter = 8'b0;
	logic [1:0] framesizecounter = 2'b11;
	logic [3:0] framecounter = 4'b0;
	logic [2:0] bytecounter = 3'b111;
	logic [2:0] statemachine = 3'b0;
	logic en, reset = 1'b0;
	logic crcin;
	logic [7:0] crcout;
	crc crccalc(en, clk, reset, crcin, crcout);

	initial begin
		TXI = 1'b1;
	end

	always@(posedge clk, posedge tf) begin
		if(tf)
			if (framesize != 4'b0) begin
				case (statemachine)
				3'b000: begin // Start state.
					// Reset the CRC.
					reset <= 1'b1;
					// Ship down the start bit.
					if (baudcounter < baudrate) begin
						TXI <= 1'b0;
						TX <= startbit;
						baudcounter += 1'b1;
					end
					else begin
						baudcounter = 8'b0;
						statemachine = 3'b001;
					end
				end
				3'b001: begin // Framesize state.
					// Turn off the reset and turn on the enable.
					reset <= 1'b0;
					en <= 1'b1;
					if (framesizecounter >= 0)
						if (baudcounter < baudrate) begin
							// Send the framesize and start calculating the crc.
							TX <= framesize[framesizecounter];
							crcin <= framesize[framesizecounter];
							baudcounter += 1'b1;
						end
						else
							baudcounter = 8'b0;
					else begin
						baudcounter = 8'b0;
						framesizecounter = 2'b11;
						statemachine = 3'b010;
					end
				end
				3'b010: begin // Framedata state.
					// Keep the CRC enable on.
					en <= 1'b1;
					// Go over each frame.
					if (framecounter < framesize)
						// Go over each byte, starting at MSB.
						if (bytecounter >= 0)
							// Do this `baud` times.
							if (baudcounter < baudrate) begin
								// Dish out the bit and keep calculating the CRC.
								// The current byte = FS * 8 + b.
								TX <= framebits[(framecounter * 8) + bytecounter];
								crcin <= framebits[(framecounter * 8) + bytecounter];
							end
							else
								baudcounter = 8'b0;
						else
							bytecounter = 3'b111;
					else begin
						framecounter = 4'b0;
						statemachine = 3'b011;
					end
				end
				3'b011: begin // CRC state.
					// Disable the CRC.
					en <= 1'b0;
					if (bytecounter >= 0)
						if (baudcounter < baudrate)
							// Dish out the CRC.
							TX <= crcout[bytecounter];
						else
							baudcounter = 8'b0;
					else begin
						bytecounter = 3'b111;
						statemachine = 3'b100;
					end
				end
				3'b100: begin // Stop state.
					if (baudcounter < baudrate)
						TX <= stopbit;
					else begin
						baudcounter = 8'b0;
						statemachine = 3'b000;
						TXI <= 1'b1;
					end
				end
				endcase
		end
	end
endmodule

