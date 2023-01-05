module apb_gpio (
  input                         PRESETn,
                                PCLK,
  input                         PSEL,
  input                         PENABLE,
  input      [7:0] PADDR,
  input                         PWRITE,
  input      [7:0] PWDATA,
  output reg [7:0] PRDATA,
  output                        PREADY,
  input  reg   [7:0] gpio_i,
  output reg [7:0] gpio_o);

  //////////////////////////////////////////////////////////////////
  //
  //                     Constants
  // 
  //////////////////////////////////////////////////////////////////

reg         [ 2:0]CASE;
reg         [7:0] mem[255:0];

localparam        IDLE =0;                                    			
localparam        SEND_ADDRESS = 1;                                            
localparam        TURN_AROUND_CYCLE = 2;         
localparam        RECIEVE_DATA = 3;				     
localparam        SEND_DATA = 4;				


  //////////////////////////////////////////////////////////////////
  //
  //                      Module Body
  //
  /////////////////////////////////////////////////////////////////

// BLOCK TO EXCUETED AT POSITIVE EDGE OF EVERY CLOCK CYCLE 
always @ (posedge PCLK)                          
begin
    case(CASE)
    // IDLE CASE
    IDLE: 						 
    if(PENABLE == 1 && PSEL == 1) 		
    begin
         CASE = SEND_ADDRESS;			
    end
    else CASE = IDLE;				
    
    // SEND_ADDRESS CASE
    SEND_ADDRESS:                             		 
    begin								
    if(PWRITE == 0)				 
    begin 
    CASE  = TURN_AROUND_CYCLE;	
    end
    else
    begin 
    CASE  = SEND_DATA;					
    end
    end
    
    //RECIEVE DATA TURN AROUND CYCLE CASE
    TURN_AROUND_CYCLE:        
    begin			     
    CASE  = RECIEVE_DATA;
    end
    
    // RECIEVE DATA CASE
    RECIEVE_DATA:					
    begin
    CASE   = IDLE;
    PRDATA = gpio_i;
//    mem[PADDR]	= PRDATA;		
    end
    
    // SEND DATA CASE
    SEND_DATA:						
    begin
    CASE    = IDLE;					
    gpio_o  = PWDATA;		 
    end
    
    // IF NO SIGNAL THEN REMAIN IDLE
    default: CASE = IDLE;			 
    
    endcase
end

// BLOCK TO BE EXECUTED AT RESET 
always @ (posedge PRESETn)                		 
begin
    CASE = IDLE;					
end

endmodule
