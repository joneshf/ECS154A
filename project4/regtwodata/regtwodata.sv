module regtwodata(input logic[7:0] idata,
							  input logic clk,
							  output logic[7:0] odata);
	
	always_ff@(posedge clk)
	begin
		odata <= idata;
	end
endmodule