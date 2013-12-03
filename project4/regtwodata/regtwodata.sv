module regtwodata(input logic clk,
						input logic wrien,
					   input logic[7:0] idata,
					   output logic[7:0] odata);
	
	always_ff@(posedge clk)
	begin
		if(wrien)
			odata <= idata;
	end
endmodule