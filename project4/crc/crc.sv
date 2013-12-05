module crc(
        input logic en,
        input logic clk,
        input logic reset,
        input logic datain,
        output logic [7:0] dataout
    );
    logic inv;
    // Decide if we're inverting anything.
    assign inv = datain ^ dataout[7];

    /*
        This module computes a CRC-8 based on some inputs.
        The general idea is that you `reset` first,
        then start feeding in the data on `datain`.
        `datain` is a bit wide, so you need to feed in each bit.
        Set the enable when you want to compute something.
        Each clock cycle it computes a new `dataout`.
        So in order to get an accurate CRC,
        you need to wait until you've feed it all the bits you have.

        @param en      Decides whether to compute the CRC or not.
        @param clk     The clock...
        @param reset   Clears the dataout to 0000 0000.
        @param datain  the bit to compute a new CRC with.
        @param dataout The calculated CRC.
    */

    always@(posedge clk or posedge reset) begin
        if (reset)
            dataout = 0;
        else if (en) begin
            // This is basically an LFSR.
            // This follows from our polynomial:
            // x^8 + x^4 + x^3 + x^2 + 1 == 1 0001 1101
            // So what happens is that we ignore the highest bit,
            // and xor each "1" in the binary representation.

            // Shift everything.
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
