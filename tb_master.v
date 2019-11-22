`timescale 1ns/1ps 


module tb_simulation;


reg clk, horizontal_reset;

wire          hsync;
wire [ 7 : 0] r;
wire [ 7 : 0] g;
wire [ 7 : 0] b;

wire enc_done;

/*always@(*) begin
 $display("%b %b %b %b",clk,r,g,horizontal_reset);
end*/

input_master 
#(.filename("/home/sathwik/imagepro/input.hex"))
	image_read
( 
    .horizontal_clock	                (clk    ),
    .horizontal_reset	            (horizontal_reset ),
    .horizontal_sync	                (hsync   ),
    .r	            (r ),
    .g	            (g ),
    .b	            (b ),
   
	.done			(enc_done)
); 

output_master 
#(.infile("/home/sathwik/imagepro/abc.bmp"))
	image_write
(
	.clock(clk),
	.reset(horizontal_reset),
	.horizontal_sync(hsync),
  .r	            (r ),
     .g	            (g ),
    .b	            (b ),
   
	.done()
);	


initial begin 
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    horizontal_reset     = 0;
    #25 horizontal_reset = 1;
end


endmodule
