`timescale 1ns/1ns

  module master_bridge(
	input [8:0]write_paddr,read_paddr,
	input [7:0] write_data,PRDATA,         
	input PRESETn,PCLK,READ_WRITE,transfer,PREADY,
	output PSEL1,PSEL2,
	output reg PENABLE,
	output reg [8:0]PADDR,
	output reg PWRITE,
	output reg [7:0]PWDATA,data_out,
	output PSLVERR ); 
       
   
  reg [2:0] state, next_state;

  reg invalid_setup_error,
      setup_error,
      invalid_read_paddr,
      invalid_write_paddr,
      invalid_write_data ;
  
  localparam IDLE = 3'b001, SETUP = 3'b010, ACCESS = 3'b100 ;


  always @(posedge PCLK)
  begin
	if(!PRESETn)
		state <= IDLE;
	else
		state <= next_state; 
  end

  always @(state,transfer,PREADY)

  begin
	if(!PRESETn)
	  next_state = IDLE;
	else
          begin
             PWRITE = ~READ_WRITE;
	     case(state)
                  
		     IDLE: begin 
		              PENABLE =0;

		            if(!transfer)
	        	      next_state = IDLE ;
	                    else
			      next_state = SETUP;
	                   end

	       	SETUP:   begin
			    PENABLE =0;

			    if(READ_WRITE) 
				 
	                       begin   PADDR = read_paddr; end
			    else 
			      begin   
			          //@(posedge PCLK)
                                  PADDR = write_paddr;
				  PWDATA = write_data;  end
			    
			    if(transfer && !PSLVERR)
			      next_state = ACCESS;
		            else
           	              next_state = IDLE;
		           end

	       	ACCESS: 
		     begin if(PSEL1 || PSEL2)
		           PENABLE =1;
			   if(transfer & !PSLVERR)
			   begin
				   if(PREADY)
				   begin
					if(!READ_WRITE)
				         begin
				          
					   next_state = SETUP; end
					else 
					   begin
					   next_state = SETUP; 
				          	   
                                           data_out = PRDATA; 
					   end
			            end
				    else next_state = ACCESS;
		              end
		             else next_state = IDLE;
			 end
			   
		       
                    				   if(PREADY)
				   begin
					if(!READ_WRITE)
				         begin
				          
					   next_state = SETUP; end
					else 
					   begin
					   next_state = SETUP; 
				          	   
                                           data_out = PRDATA; 
					   end
			            end
				    else next_state = ACCESS;
		              end
		             else next_state = IDLE;
			 end
			   
		       
                             
                       
                                 default: next_state = IDLE; 
               	endcase
             end
          end


 
     assign {PSEL1,PSEL2} = ((state != IDLE) ? (PADDR[8] ? {1'b0,1'b1} : {1'b1,1'b0}) : 2'd0);

  // PSLVERR LOGIC
  
  always @(*)
       begin
        if(!PRESETn)
	    begin 
	     setup_error =0;
	     invalid_read_paddr = 0;
	     invalid_write_paddr = 0;
	     invalid_write_paddr =0 ;
	    end
        else
	 begin	
          begin
	  if(state == IDLE && next_state == ACCESS)
   		  setup_error = 1;
	  else setup_error = 0;
          end
          begin
          if((write_data===8'dx) && (!READ_WRITE) && (state==SETUP || state==ACCESS))
		  invalid_write_data =1;
	  else invalid_write_data = 0;
          end
          begin
	  if((read_paddr===9'dx) && READ_WRITE && (state==SETUP || state==ACCESS))
		  invalid_read_paddr = 1;
	  else  invalid_read_paddr = 0;
          end
          begin
          if((write_paddr===9'dx) && (!READ_WRITE) && (state==SETUP || state==ACCESS))
		  invalid_write_paddr =1;
          else invalid_write_paddr =0;
          end
          begin
	  if(state == SETUP)
            begin
                 if(PWRITE)
                      begin
                         if(PADDR==write_paddr && PWDATA==write_data)
                              setup_error=1'b0;
                         else
                               setup_error=1'b1;
                       end
                 else 
                       begin
                          if (PADDR==read_paddr)
                                 setup_error=1'b0;
                          else
                                 setup_error=1'b1;
                       end    
              end 
          
         else setup_error=1'b0;
         end 
       end
       invalid_setup_error = setup_error ||  invalid_read_paddr || invalid_write_data || invalid_write_paddr  ;
     end 

   assign PSLVERR =  invalid_setup_error ;

	 

 endmodule         
                       
                                 default: next_state = IDLE; 
               	endcase
             end
          end


 
     assign {PSEL1,PSEL2} = ((state != IDLE) ? (PADDR[8] ? {1'b0,1'b1} : {1'b1,1'b0}) : 2'd0);

  // PSLVERR LOGIC
  
  always @(*)
       begin
        if(!PRESETn)
	    begin 
	     setup_error =0;
	     invalid_read_paddr = 0;
	     invalid_write_paddr = 0;
	     invalid_write_paddr =0 ;
	    end
        else
	 begin	
          begin
	  if(state == IDLE && next_state == ACCESS)
   		  setup_error = 1;
	  else setup_error = 0;
          end
          begin
          if((write_data===8'dx) && (!READ_WRITE) && (state==SETUP || state==ACCESS))
		  invalid_write_data =1;
	  else invalid_write_data = 0;
          end
          begin
	  if((read_paddr===9'dx) && READ_WRITE && (state==SETUP || state==ACCESS))
		  invalid_read_paddr = 1;
	  else  invalid_read_paddr = 0;
          end
          begin
          if((write_paddr===9'dx) && (!READ_WRITE) && (state==SETUP || state==ACCESS))
		  invalid_write_paddr =1;
          else invalid_write_paddr =0;
          end
          begin
	  if(state == SETUP)
            begin
                 if(PWRITE)
                      begin
                         if(PADDR==write_paddr && PWDATA==write_data)
                              setup_error=1'b0;
                         else
                               setup_error=1'b1;
                       end
                 else 
                       begin
                          if (PADDR==read_paddr)
                                 setup_error=1'b0;
                          else
                                 setup_error=1'b1;
                       end    
              end 
          
         else setup_error=1'b0;
         end 
       end
       invalid_setup_error = setup_error ||  invalid_read_paddr || invalid_write_data || invalid_write_paddr  ;
     end 

   assign PSLVERR =  invalid_setup_error ;

	 

 endmodule
