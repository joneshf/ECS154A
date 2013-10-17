library verilog;
use verilog.vl_types.all;
entity EightBitRot is
    port(
        B               : out    vl_logic_vector(7 downto 0);
        \ROR\           : in     vl_logic;
        A               : in     vl_logic_vector(7 downto 0);
        \ROL\           : in     vl_logic
    );
end EightBitRot;
