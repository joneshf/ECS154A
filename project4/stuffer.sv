module bitstuffer(input logic clk,
						input logic enable,
						input logic txin,
						input logic [7:0] baudrate,
						output logic txout);
	
	logic [7:0] baudcounter = 8'b1;
	logic [4:0] lastfivebits;
	logic backlog, stuffholder, currbit;
	
	always@(posedge clk) begin
		if(enable) begin
			if(baudcounter < baudrate) begin
				baudcounter <= baudcounter + 1'b1;
				if(~backlog) begin
					txout <= currbit;
				end else begin
					// we need to push from the backlog instead of the current bit.
					txout <= stuffholder;
				end
			end else begin
				lastfivebits <= {lastfivebits[3:0], currbit};
				baudcounter <= 8'b1;
				if(backlog) begin
					backlog <= 1'b0;
				end
				if(&lastfivebits | &(~lastfivebits)) begin
					// we are in need of a stuff
					stuffholder <= currbit;
					backlog <= 1'b1;
					currbit <= ~currbit;
				end else begin
					// we don't need to stuff.
					currbit <= txin;
				end
			end
		end
	end
endmodule