module transmitter(	input logic clk,
							input logic tf,
							input logic [3:0] framesize,
							input logic [127:0] framebits,
							input logic [7:0] baudrate,
							output logic TXI,
							output logic TX);

	logic startbit = 1'b1;
	logic stopbit = 1'b0;
	
	logic [7:0] baudcounter;
	logic [3:0] framecounter;
	logic [2:0] bytecounter, statemachine;
	logic [1:0] framesizecounter;
	
	logic en, reset = 1'b0;
	logic crcin;
	logic [7:0] crcout;
	
	logic initializer;
	
	initial begin
		TXI = 1'b1;
		TX = 1'b0;
		initializer = 1'b1;
	end
	
	crc crccalc(en, clk, reset, crcin, crcout);
	
	always_ff@(posedge clk) begin
		if(tf) begin
			if(framesize > 4'b0) begin
				TXI <= 1'b0;
				if(initializer) begin
					baudcounter <= 8'd2;
					framesizecounter <= 2'b11;
					statemachine <= 3'b0;
					framecounter <= 4'b0;
					bytecounter <= 3'b111;
					initializer <= 1'b0;
				end
				case(statemachine)
				
					3'b000: begin
						reset <= 1'b1;
						if(baudcounter < baudrate) begin
							TX <= startbit;
							baudcounter <= baudcounter + 1'b1;
						end
						else begin	
							statemachine <= 3'b001;
							baudcounter <= 8'd2;
						end
					end
					
					3'b001: begin
						reset <= 1'b0;
						en <= 1'b1;
						crcin <= framesize[framesizecounter];
						if(framesizecounter >= 2'b00) begin
							if(baudcounter < baudrate) begin
								TX <= framesize[framesizecounter];
								baudcounter <= baudcounter + 1'b1;
							end
							else begin
								if(framesizecounter - 1'b1 == 2'b11) begin
									baudcounter <= 8'd2;
									statemachine <= 3'b010;
								end
								else begin	
									baudcounter <= 8'b1;
									framesizecounter <= framesizecounter - 1'b1;
								end
							end
						end
					end
					
					3'b010: begin
						crcin <= framebits[(framecounter * 8) + bytecounter];
						if(framecounter < framesize) begin
							if(bytecounter >= 3'b0) begin
								if(baudcounter < baudrate) begin
									TX <= framebits[(framecounter * 8) + bytecounter];
									baudcounter <= baudcounter + 1'b1;
								end
								else begin
									if(bytecounter - 1'b1 == 3'b111) begin
										if(framecounter + 1'b1 == framesize) begin
											bytecounter <= bytecounter - 1'b1;
											baudcounter <= 8'd2;
											en <= 1'b0;
											statemachine <= 3'b011;
										end
										else begin
											baudcounter <= 8'b1;
											bytecounter <= bytecounter - 1'b1;
											framecounter <= framecounter + 1'b1;
										end
									end
									else begin
										baudcounter <= 8'b1;
										bytecounter <= bytecounter - 1'b1;
									end
								end
							end
						end
					end
					
					3'b011: begin
						if(bytecounter >= 3'b0) begin
							if(baudcounter < baudrate) begin
								TX <= crcout[bytecounter];
								baudcounter <= baudcounter + 1'b1;
							end
							else begin
								if(bytecounter - 1'b1 == 3'b111) begin
									statemachine <= 3'b100;
									baudcounter <= 8'b1;
								end
								else begin
									bytecounter <= bytecounter - 1'b1;
									baudcounter <= 8'b1;
								end
							end
						end
					end
					
					3'b100: begin
						if(baudcounter < baudrate) begin
							TX <= stopbit;
							baudcounter <= baudcounter + 1'b1;
						end
						else begin
							TXI <= 1'b1;
						end
					end
					
					default: TX <= 1'b0;
				endcase
			end
		end
		else begin // else tf
			initializer <= 1'b1;
		end
	end

endmodule

