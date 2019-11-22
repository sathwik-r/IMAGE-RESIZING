`timescale 1ns / 1ps



module input_master
#( parameter filename="/home/sathwik/imagepro/input.hex"


    )
    (
    input horizontal_clock,
    input horizontal_reset,
    
    output reg horizontal_sync,
    output reg [7:0] r,
    output reg [7:0] g,
    output reg [7:0] b,
    output done
    
    );
  reg [1:0] current_state,next_state;
  reg begin_;
  reg control_horizontal_sync_start;
  reg [8:0] control_horizontal_sync_counter;
  reg control_pixel_start;
  reg [7:0] memory[0:512*768*3-1];
 integer temp_memory[0:512*768*3-1];
 integer red[0:512*768-1];
 integer blue[0:512*768-1];
 integer green[0:512*768-1];
 integer gg;
  reg [10:0] row;
  reg [10:0] column;
  reg [18:0] pixel_count;
  reg reset;
  localparam  state_none = 2'b00,
                state_horizontal_sync = 2'b10,
                state_pixel = 2'b11;
  initial begin
  $readmemh(filename,memory,0, 512*768*3-1);
  end 
 always@(posedge horizontal_clock ,negedge horizontal_reset) 
 begin
 if(~horizontal_reset)
     begin
         control_horizontal_sync_counter <=0;
         end
         else begin
             if(control_horizontal_sync_start)
                 begin
                    control_horizontal_sync_counter = control_horizontal_sync_counter +1;
                 end
                 else
                 begin
                 control_horizontal_sync_counter <=0;
         end
     end
      if(~horizontal_reset)
     begin
         pixel_count <=0;
         end
         else begin
             if(control_pixel_start)
                 begin
                    pixel_count = pixel_count +1;
                 end
                
     end
     if(~horizontal_reset)
     begin
         row <=0;
         column<=0;
         
         end
         else begin
             if(control_pixel_start)
                 begin
                   if(column == 768 -1)
                   begin
                        row <=row + 1; 
                   end
                   if(column == 768 -1)
                   begin
                        column<=0; 
                   end
                   else
                   begin
                        column <=column + 1; 
                   end
                   
                 end
                
     end
  if(~horizontal_reset)
     begin
        begin_<=0;
        reset<=0;
         end
         else begin
          reset<=horizontal_reset;
          if(reset==1'b0 &&horizontal_reset==1'b1 )
            begin_<=1'b1;
           else
            begin_<=1'b0;
                 end
    if(~horizontal_reset)
     begin
         current_state<=state_none;
         end
         else begin
          current_state<=next_state;
                   
                 end
                              
 end
 
 integer i,j;
  always@(begin_) 
 begin
 if(begin_==1'b1)
    begin
     for( i=0;i<512*768*3 ;i=i+1)
     
        begin
            temp_memory[i]=memory[i][7:0];
             // $display("done11 %b",temp_memory[i]);
        end
         //$display("done11 %b",temp_memory[2519]);
         // $display("done11 %b",temp_memory[2570]);
     for( i=0;i<512 ;i=i+1)
     
     begin
     
      for( j=0;j<768 ;j=j+1)
      
      begin
      gg=768*3*(512-i-1)+3*j+0;
       
      
      red[768*i+j] =temp_memory[gg];
     // $display("done110 %b %b",red[gg],gg);
    //  $display("done11 %b %b %b %b",red[768*i+j],temp_memory[768*3*(512-i-1)+3*j+0],i,j);
     green[768*i+j] =temp_memory[768*3*(512-i-1)+3*j+1];
        blue[768*i+j] =temp_memory[768*3*(512-i-1)+3*j+2];
      //  $display("done110 %b %b",blue[gg],gg);
      end
     end
    end     
 
 end
  always@(*)begin
      horizontal_sync=1'b0;
      r=0;
      b=0;
      g=0;
      if(control_pixel_start)
      begin
         horizontal_sync=1'b1;
         r=red[768*row+column];
         g=green[768*row+column];
         b=blue[768*row+column];
         //$display("done110 %b %b",r,g);
      end
  
  
  end
 
 
 
 always@(*) begin 
    case(current_state)
        state_none:begin
            if(begin_)
                next_state=state_horizontal_sync;
            else
                next_state=state_none;    
        end
       state_horizontal_sync:begin
                   if(control_horizontal_sync_counter==160)
                next_state=state_pixel;
            else
                next_state=state_horizontal_sync;  
       end
       state_pixel:begin

             if(done)
                next_state=state_none;
            else begin
                if(column==768-1)
                    next_state=state_horizontal_sync;
                else
                next_state=state_pixel;    
            end
            end
       endcase
 end   
   
 
 always@(*) begin 
     control_horizontal_sync_start = 0;
     control_pixel_start = 0;
     case(current_state)
            state_horizontal_sync : begin control_horizontal_sync_start = 1; end
            state_pixel : begin control_pixel_start = 1; end
     endcase
 end


 
 //always@(*) begin
 //$display("%b %b %b %b",r,g,b,horizontal_clock);
//end
  
endmodule
