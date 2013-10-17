library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        C               : out    vl_logic_vector(7 downto 0);
        CIN             : in     vl_logic;
        A               : in     vl_logic_vector(7 downto 0);
        B               : in     vl_logic_vector(7 downto 0);
        S               : in     vl_logic_vector(2 downto 0)
    );
end alu;
