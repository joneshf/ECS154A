module stuffer(	input logic clk,
						input logic enable,
						input logic txin,
						input logic [7:0] baudrate,
						output logic txi,
						output logic txout
						// debug
						//,
						//output logic [7:0] buffersize,
						//output logic [7:0] bufferoffset,
						//output logic [7:0] baudcounter,
						//output logic [169:0] buffer
						);
	
	logic [169:0] buffer; // could use some diff eq to find out the actual max of what the buffer could be
	logic [2:0] fivecounter;
	logic [7:0] buffersize;
	logic [7:0] bufferoffset = 8'b1;
	logic [7:0] baudcounter = 8'b1;
	
	initial begin
		txi = 1'b1;
		// debug
		//bufferoffset = 8'b1;
		//baudcounter = 8'b1;
	end
		
	
	always@(posedge clk) begin
		
		if(fivecounter == 3'b101) begin
			if(&(buffer[4:0]) | &(~(buffer[4:0]))) begin
				if(enable) begin
					buffer <= {buffer[167:0], ~buffer[0], txin};
					buffersize <= buffersize + 2'b10;
				end
			end else begin
				if(enable) begin
					buffer <= {buffer[168:0], txin};
					buffersize <= buffersize + 1'b1;
				end
			end
		end else begin
			if(enable) begin
				buffer <= {buffer[168:0], txin};
				buffersize <= buffersize + 1'b1;
				fivecounter <= fivecounter + 1'b1;
			end
		end
		
		if(buffersize > 8'b0) begin
			txi <= 1'b0;
			if(baudcounter < baudrate) begin
				txout <= buffer[buffersize - bufferoffset];
				baudcounter <= baudcounter + 1'b1;
			end else begin
				if(buffersize == bufferoffset) begin
					// they are equal, and we are done.
					txout <= 1'b0;
					buffersize <= 8'b0;
					bufferoffset <= 8'b0;
					baudcounter <= 8'b1;
				end else begin
					baudcounter <= 8'b1;
					bufferoffset <= bufferoffset + 1'b1;
				end
			end
		end else begin
			txi <= 1'b1;
		end
	end
	
endmodule
