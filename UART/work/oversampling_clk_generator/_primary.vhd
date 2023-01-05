library verilog;
use verilog.vl_types.all;
entity oversampling_clk_generator is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        rate_bd         : in     vl_logic_vector(31 downto 0);
        oversampling_factor: in     vl_logic_vector(4 downto 0);
        oversampling_clock: out    vl_logic
    );
end oversampling_clk_generator;
