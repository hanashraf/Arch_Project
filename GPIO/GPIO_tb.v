`include "GPI.v"
`timescale 1ns/1ns
module TEST;
  reg PCLK,PRESETn;
  reg [7:0]PADDR;
  reg [7:0]PWDATA;
  wire[7:0]PRDATA;
  reg [7:0]mem[255:0];
  reg PSEL;
  reg PENABLE;
  
  

apb_gpio TESTGPIO(
                          PRESETn,
                          PCLK,
                          PSEL,
                          PENABLE,
                          PADDR,
                          PWRITE,
                          PWDATA,
                          PRDATA,
                          PREADY,
                          gpio_i,
                          gpio_o);

initial
   begin
    PCLK <= 0;
    forever #5 PCLK = ~PCLK;
   end
   
 initial $readmemh("check.mem",mem);  
   
initial
   begin 
     @(posedge PCLK) PSEL = 1;PENABLE = 1;PRESETn=1;
     repeat(5) @(posedge PCLK) PADDR = 8'd1;
     repeat(10) @(posedge PCLK) PWDATA = 8'd9;
     repeat(10) @(posedge PCLK) PWDATA = 8'd15;

     
    
   end   
   
endmodule
