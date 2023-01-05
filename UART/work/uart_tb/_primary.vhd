library verilog;
use verilog.vl_types.all;
entity uart_tb is
    generic(
        c_CLOCK_PERIOD_NS: integer := 100;
        c_CLKS_PER_BIT  : integer := 87;
        c_BIT_PERIOD    : integer := 8600
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of c_CLOCK_PERIOD_NS : constant is 1;
    attribute mti_svvh_generic_type of c_CLKS_PER_BIT : constant is 1;
    attribute mti_svvh_generic_type of c_BIT_PERIOD : constant is 1;
end uart_tb;
