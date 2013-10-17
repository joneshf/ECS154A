library verilog;
use verilog.vl_types.all;
entity \4-bit-carry-lookahead-adder\ is
    port(
        C_OUT           : out    vl_logic;
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        C_IN            : in     vl_logic;
        S               : out    vl_logic_vector(3 downto 0)
    );
end \4-bit-carry-lookahead-adder\;
