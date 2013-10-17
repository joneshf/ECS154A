library verilog;
use verilog.vl_types.all;
entity EightBitAdd_vlg_check_tst is
    port(
        C_OUT           : in     vl_logic;
        S               : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end EightBitAdd_vlg_check_tst;
