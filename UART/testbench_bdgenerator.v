module testbench_bd();
  // Declare input and output signals for the MUT
  reg clk, rst;
  reg [31:0] rate_bd;
  wire clk_bd;

  // Instantiate the MUT
  bd_generator MUT (
    .clk(clk),
    .rst(rst),
    .rate_bd(rate_bd),
    .clk_bd(clk_bd)
  );

  // Initialize input signals and registers
  initial begin
    clk = 0;
    rst = 1;
    rate_bd = 5000000;  // 5 MHz baud rate
    #10 rst = 0;
  end

  // Apply stimuli to the MUT and observe the output responses
  always begin
    #5 clk = ~clk;
  end

  // Print out input and output signals
  initial begin
    $monitor("rate_bd=%d clk_bd=%d", rate_bd, clk_bd);
  end

  // Test case 1: change baud rate
  initial begin
    #150 rate_bd = 1000000;  // 1 MHz baud rate
  end
endmodule



