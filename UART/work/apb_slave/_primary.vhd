library verilog;
use verilog.vl_types.all;
entity apb_slave is
    port(
        P_clk           : in     vl_logic;
        P_resetn        : in     vl_logic;
        P_sel           : in     vl_logic;
        P_enable        : in     vl_logic;
        P_write         : in     vl_logic;
        P_address       : in     vl_logic_vector(7 downto 0);
        PW_data         : in     vl_logic_vector(7 downto 0);
        PR_data         : out    vl_logic_vector(7 downto 0);
        P_ready         : out    vl_logic
    );
end apb_slave;
