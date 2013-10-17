library verilog;
use verilog.vl_types.all;
entity EightBitNot is
    port(
        B               : out    vl_logic_vector(7 downto 0);
        A               : in     vl_logic_vector(7 downto 0)
    );
end EightBitNot;
