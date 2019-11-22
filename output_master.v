`timescale 1ns / 1ps



module output_master
#( parameter infile="/home/sathwik/imagepro/abc.bmp"
    )
    (
        input clock,
        input reset,
        input horizontal_sync,
        input [7:0]r,
        input [7:0]g,
        input [7:0]b,
        output reg done
    
    );
integer BMP_head_codes[0:54-1];
reg [7:0]output_BMP [0:512*768*3*4-1];
reg [20:0] counter;
integer i,k,l,m;
wire ok;
initial begin

BMP_head_codes[0] = 66;
BMP_head_codes[1] = 77 ;
BMP_head_codes[2] = 36 ;
BMP_head_codes[3] = 0 ;
BMP_head_codes[4] = 60 ;
BMP_head_codes[5] = 0 ;
BMP_head_codes[6] = 0 ;
BMP_head_codes[7] = 0 ;
BMP_head_codes[8] = 0 ;
BMP_head_codes[9] = 0 ;
BMP_head_codes[10] = 54;
BMP_head_codes[11] = 0;
BMP_head_codes[12] = 0 ;
BMP_head_codes[13] = 0 ;
BMP_head_codes[14] = 40 ;
BMP_head_codes[15] = 0 ;
BMP_head_codes[16] = 0 ;
BMP_head_codes[17] = 0 ;
BMP_head_codes[18] = 0 ;
BMP_head_codes[19] = 6 ;
BMP_head_codes[20] = 0 ;
BMP_head_codes[21] = 0 ;
BMP_head_codes[22] = 0 ;
BMP_head_codes[23] = 4 ;
BMP_head_codes[24] = 0 ;
BMP_head_codes[25] = 0 ;
BMP_head_codes[26] = 1 ;
BMP_head_codes[27] = 0 ;
BMP_head_codes[28] = 24;
BMP_head_codes[29] = 0 ;
BMP_head_codes[30] = 0 ;
BMP_head_codes[31] = 0 ;
BMP_head_codes[32] = 0 ;
BMP_head_codes[33] = 0 ;
BMP_head_codes[34] = 0 ;
BMP_head_codes[35] = 0 ;
BMP_head_codes[36] = 0 ;
BMP_head_codes[37] = 0 ;
BMP_head_codes[38] = 0 ;
BMP_head_codes[39] = 0 ;
BMP_head_codes[40] = 0 ;
BMP_head_codes[41] = 0 ;
BMP_head_codes[42] = 0 ;
BMP_head_codes[43] = 0 ;
BMP_head_codes[44] = 0 ;
BMP_head_codes[45] = 0 ;
BMP_head_codes[46] = 0 ;
BMP_head_codes[47] = 0 ;
BMP_head_codes[48] = 0 ;
BMP_head_codes[49] = 0 ;
BMP_head_codes[50] = 0 ;
BMP_head_codes[51] = 0 ;
BMP_head_codes[52] = 0 ;
BMP_head_codes[53] = 0 ;
end

always@(posedge clock , negedge reset)
begin
    if(!reset)
    begin
        l<=0;
        m<=0;
    end 
    else begin
        if(horizontal_sync)begin
            if(m==768-1)begin // check for 768/2
                m<=0;
                l<=l+2;
            end
           else begin
            m<=m+1; 
            
        end
end 
end
end
always@(posedge clock , negedge reset)
begin
if(!reset)begin
for(k=0;k<512*768*3*2*2;k=k+1)
begin
    output_BMP[k]<=0;
end
end
else begin
    if(horizontal_sync)begin
        output_BMP[2*768*3*(2*512-l-1)+6*m+2]<=r; //removed 2
        output_BMP[2*768*3*(2*512-l-1)+6*m+1]<=g;
        output_BMP[2*768*3*(2*512-l-1)+6*m+0]<=b;
        output_BMP[2*768*3*(2*512-l-1)+6*m+5]<=r;
        output_BMP[2*768*3*(2*512-l-1)+6*m+4]<=g;
        output_BMP[2*768*3*(2*512-l-1)+6*m+3]<=b;
        
        output_BMP[2*768*3*(2*512-l-1-1)+6*m+2]<=r;
        output_BMP[2*768*3*(2*512-l-1-1)+6*m+1]<=g;
        output_BMP[2*768*3*(2*512-l-1-1)+6*m+0]<=b;
        output_BMP[2*768*3*(2*512-l-1-1)+6*m+5]<=r;
        output_BMP[2*768*3*(2*512-l-1-1)+6*m+4]<=g;
        output_BMP[2*768*3*(2*512-l-1-1)+6*m+3]<=b;
    end
end

end
always@(posedge clock , negedge reset)
begin
    if(~reset)
        begin
        // $display("done6");
            counter<=0;
        end    
    else begin
             if(horizontal_sync)   
                counter<=counter+20'b1;
                // $display("done5 %b",counter);
                
        end    

end
assign ok=(counter==2*384*512-1)?1'b1:1'b0; 
always@(posedge clock , negedge reset)
begin
    if(!reset)
        begin
            done<=0;
        end    
    else begin
          done<=ok;
        end    

end
integer file;
integer p;
initial begin
//$display("done1");
    file=$fopen(infile,"wb+");
   // $display("done4");
 end   
always@(done)begin
    if(done==1'b1)begin
   // $display("done2");
        for( p=0;p<54;p=p+1)
        begin
        //$display("done3");
            $fwrite(file,"%c",BMP_head_codes[p][7:0]);
       end
       for(p=0;p<768*512*3*4;p=p+3)  
       begin
         $fwrite(file,"%c",output_BMP[p][7:0]);
        $fwrite(file,"%c",output_BMP[p+1][7:0]);
       $fwrite(file,"%c",output_BMP[p+2][7:0]);
        // $display("done");
       end
       
       
    end


end
    
endmodule
