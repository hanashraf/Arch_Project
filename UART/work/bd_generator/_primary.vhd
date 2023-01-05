library verilog;
use verilog.vl_types.all;
entity bd_generator is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        rate_bd         : in     vl_logic_vector(31 downto 0);
        clk_bd          : out    vl_logic
    );
end bd_generator;
