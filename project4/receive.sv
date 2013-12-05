module receive(input logic clk,
					input logic rx,
					input logic [7:0] baudrate,
					output logic dr, nf, over, fe,
					output logic [7:0] dataout);

	logic [127:0] framedata;  			//the data in the frame
	logic [7:0] framecrc;				//i don't know what this is
	logic [3:0] framesize;				//how big each frame should be
	logic [3:0] statemachine = 3'b0;
	//logic [255:0] crazycookie;
	logic [7:0] clkcount = 8'b0;  	//internal clk count
	logic [7:0] ones, zeros;
	logic [1:0] fsincrement = 2'b0;		//increments through framesize (3..0) to input rx bits
	logic [1:0] fscounter = 2'b0;			//counter to increment rx
	logic [2:0] byteincrement = 3'b0;	//increments through byte0 (7..0) to input rx bits
	logic [2:0] bytecounter = 3'b0;		//counter to increment rx
	logic moreofbit;

	initial begin
		nf = 1'b0;
		dr = 1'b0;
	end

	always@(posedge clk)
	begin
		//noise flag logic
		if(clkcount < baudrate)				//go through the if statement baudrate times
		begin
			if(rx == 1'b0)
				zeros = zeros + 1'b1;		//increment zeros if rx = 0
			else
				ones = ones + 1'b1;			//increment ones if rx = 1
			clkcount <= clkcount + 1'b1;	
		end

		if(zeros < ones)						//if there are more ones than zeros
		begin
			moreofbit <= 1'b1;				//we have more ones
			if(zeros > 2'b10)					//if two clk times are measured with a diff. value than the moreofbit
				nf <= 1'b1;						//noise flag is set to one 
		end
		else if(ones < zeros)
		begin
			moreofbit <= 1'b0;
			if(ones > 2'b10)
				nf <= 1'b1;
		end
		//end noise flag logic 
		
		case(statemachine)
			3'b000: begin
				//this is the start bit
				if(rx == 1'b1 & nf == 0)begin						//we only begin if the start bit is one and it isn't noise, otherwise ignore
					statemachine <= statemachine + 1'b1;
					clkcount <= 8'b0;
				end
			end
			3'b001: begin
				//bits 1-4 are frame size
				//this is kind of right except it needs to also account for the clock so rx will send in the next bit
				framesize = 4'b0;
				if(fsincrement != 2'b11) begin
					framesize[3] = rx;
					//here the rx needs to update to the next bit
					framesize[2] = rx;
					//the rx needs to update again
					framesize[1] = rx;
					//the rx needs to update again
					framesize[0] = rx;
					fsincrement = fsincrement + 1'b1;
				end
				statemachine <= statemachine + 1'b1;
			end
			3'b010: begin
				//first data byte
				if(byteincrement != 3'b111)begin
					framedata[7] = rx;
					//rx needs to update
					framedata[6] = rx;
					//rx needs to update
					framedata[5] = rx;
					//rx needs to update
					framedata[4] = rx;
					//rx needs to update
					framedata[3] = rx;
					//rx needs to update
					framedata[2] = rx;
					//rx needs to update
					framedata[1] = rx;
					//rx needs to update
					framedata[0] = rx;
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
				//if the over bit hasn't been set, this else statement would figure out how many rx bits go into framedata 
				//remember that the first byte has already been input, so it would start at 15..8 and then go to FS*8-1..FS*7


			end
			3'b100: begin
				//this is for CRC
				//have to check for crc error by comparing the values from the crc rx bits 
				//to the calculated crc

			end
			3'b101: begin
				//this is for the stop bit
				//fe gets set if the stop bit is one or if there are missing stuff bits
				
			end
		endcase

	end



endmodule
