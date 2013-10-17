library verilog;
use verilog.vl_types.all;
entity EightBitAdd is
    port(
        C_OUT           : out    vl_logic;
        C_IN            : in     vl_logic;
        A_IN            : in     vl_logic_vector(7 downto 0);
        B_IN            : in     vl_logic_vector(7 downto 0);
        S               : out    vl_logic_vector(7 downto 0)
    );
end EightBitAdd;
