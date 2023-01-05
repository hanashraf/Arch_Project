library verilog;
use verilog.vl_types.all;
entity baud_rate_generator is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        baud_rate       : in     vl_logic_vector(31 downto 0);
        baud_clk        : out    vl_logic
    );
end baud_rate_generator;
