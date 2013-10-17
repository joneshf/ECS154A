library verilog;
use verilog.vl_types.all;
entity FourBitcarryLookaheadAdder is
    port(
        C_OUT           : out    vl_logic;
        B               : in     vl_logic_vector(3 downto 0);
        A               : in     vl_logic_vector(3 downto 0);
        C_IN            : in     vl_logic;
        S               : out    vl_logic_vector(3 downto 0)
    );
end FourBitcarryLookaheadAdder;
