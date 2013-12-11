module registers(input logic clk,
							  input logic wrien,
							  input logic[7:0] idata,
							  output logic[7:0] odata);
	
	always_ff@(posedge clk)
	begin
		if(wrien)
			odata <= idata;
	end
	/*	
	idata[0] = fe 			//frame error bit
	idata[1] = crce 		//crce bit
	idata[2] = ore   		//overrun error bit
	idata[3] = nf	 		//noise flag bit
	idata[4] = txi	 		//transmitter idle bit
	idata[5] = tbnf   	//transmit buffer not full bit
	idata[6] = dr	  		//data ready bit
	*/
	
endmodule