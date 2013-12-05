module crc(
        input logic nextbit,
        input logic clk,
        input logic reset,
        output logic [7:0] dataout
    );
    logic inv;
    assign inv = nextbit ^ dataout[7];

    always@(posedge clk or posedge reset) begin
        if (reset)
            dataout = 0;
        else begin
            dataout[7] = dataout[6];
            dataout[6] = dataout[5];
            dataout[5] = dataout[4];
            dataout[4] = dataout[3] ^ inv;
            dataout[3] = dataout[2] ^ inv;
            dataout[2] = dataout[1] ^ inv;
            dataout[1] = dataout[0];
            dataout[0] = inv;
        end
    end
endmodule
