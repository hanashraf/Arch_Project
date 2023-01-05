
`timescale 1ns/1ns



module slave2(
         input PCLK,PRESETn,
         input PSEL,PENABLE,PWRITE,
         input [7:0]PADDR,PWDATA,
        output [7:0]PRDATA2,
        output reg PREADY );
    
     reg [7:0]addr;

     reg [7:0] memomry [0:63];

    assign PRDATA2 =  memomry[addr];



    always @(*)
       begin
         if(!PRESETn)
              PREADY = 0;
          else
	  if(PSEL && !PENABLE && !PWRITE)
	     begin PREADY = 0; end
	         
	  else if(PSEL && PENABLE && !PWRITE)
	     begin  PREADY = 1;
                    addr =  PADDR; 
	       end
          else if(PSEL && !PENABLE && PWRITE)
	     begin  PREADY = 0; end

	  else if(PSEL && PENABLE && PWRITE)
	     begin  PREADY = 1;
	            memomry[PADDR] = PWDATA; end

           else PREADY = 0;
        end
    endmodule
