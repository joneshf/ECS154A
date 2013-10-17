library verilog;
use verilog.vl_types.all;
entity EightBitXor is
    port(
        C               : out    vl_logic_vector(7 downto 0);
        A               : in     vl_logic_vector(7 downto 0);
        B               : in     vl_logic_vector(7 downto 0)
    );
end EightBitXor;
