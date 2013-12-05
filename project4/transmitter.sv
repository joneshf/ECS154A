module transmitter(	input logic clk,
							input logic tf,
							input logic [3:0] framesize,
							input logic [127:0] framebits,
							input logic [7:0] baudrate,
							output logic TXI,
							output logic TX);

	logic startbit = 1'b1;
	logic stopbit = 1'b0;
	//logic [7:0] counter1, counter2, counter3, counter4, counter5 = 8'b0;
	logic [2:0] statemachine = 3'b0;
	logic en, reset = 1'b0;
	logic crcin;
	logic [7:0] crcout;
	crc crccalc(en, clk, reset, crcin, crcout);

	initial begin
		TXI = 1'b1;
	end

	always@(posedge clk, posedge tf) begin
		if(tf & (framesize != 4'b0)) begin
			case (statemachine)
			3'b000: begin // Start state.
				TXI <= 1'b0;

				// Reset the CRC.
				reset <= 1'b1;
				// Ship down the start bit.
				for(int i = 0; i < baudrate; ++i)
					TX <= startbit;
			end
			3'b001: begin // Framesize state.
				// Turn off the reset and turn on the enable.
				reset <= 1'b0;
				en <= 1'b1;
				for(int jj = 3; jj >= 0; --jj)
					// Send the framesize and start calculating the crc.
					for(int j = 0; j < baudrate; ++j) begin
						TX <= framesize[jj];
						crcin <= framesize[jj];
					end
			end
			3'b010: begin // Framedata state.
				// Keep the CRC enable on.
				en <= 1'b1;
				for(int kk = 0; kk < framesize; ++kk)
					for(int kkj = 7; kkj >= 0; --kkj)
						for(int k = 0; k < baudrate; ++k) begin
							TX <= framebits[(kk * 8) + kkj];
							crcin <= framebits[(kk * 8) + kkj];
						end
			end
			3'b011: begin // CRC state.
				// Disable the CRC.
				en <= 1'b0;
				for(int l = 7; l >= 0; --l)
					for(int ll = 0; ll < baudrate; ++ll)
						TX <= crcout[i];
			end
			3'b100: begin // Stop state.
				for(int m = 0; m < baudrate; ++m)
					TX <= stopbit;

				TXI <= 1'b1;
			end
			endcase
		end
	end
endmodule

