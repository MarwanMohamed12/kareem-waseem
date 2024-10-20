module asser(if_pe.Assertions if_t);

property rst;
@(posedge if_t.clk)  if_t.rst==1'b1 |=> ( if_t.Y==2'b00 && if_t.valid ==1'b0);
endproperty

property valid_bit;
@(posedge if_t.clk) disable iff(if_t.rst) (($countones(if_t.D) > 0) |=> if_t.valid);
endproperty

property Bit_0;
@(posedge if_t.clk) disable iff(if_t.rst)  
    if_t.D[0] |=> if_t.Y==2'b11;
endproperty

property Bit_1;
@(posedge if_t.clk) disable iff(if_t.rst)  

    (if_t.D[1] && ! if_t.D[0]) |=> if_t.Y==2'b10 ;

endproperty
property Bit_2;
@(posedge if_t.clk) disable iff(if_t.rst)  
    (if_t.D[2] && !if_t.D[1] &&  ! if_t.D[0]  ) |=> if_t.Y==2'b01 ;
endproperty
property Bit_3;
@(posedge if_t.clk) disable iff(if_t.rst)  
    ( if_t.D[3] && !if_t.D[2] && !if_t.D[1] &&  ! if_t.D[0]  ) |=> if_t.Y==2'b00 ;
endproperty

rst_check:assert property (rst)else $error("reset=%0d,valid=%0d,D=%0d,y=%0d",if_t.rst,(if_t.Y |if_t.valid) ,if_t.D,if_t.Y); 
valid_bit_check:assert property (valid_bit)else $error("reset=%0d,valid=%0d,D=%0d,y=%0d",if_t.rst,($countones(if_t.D) > 0),if_t.D,if_t.Y);

output_c0:assert property (Bit_0) else $error("reset=%0d,valid=%0d,D=%0d,y=%0d",if_t.rst,$countones(if_t.D),if_t.D,if_t.Y);
output_c1:assert property (Bit_1) else $error("reset=%0d,valid=%0d,D=%0d,y=%0d",if_t.rst,$countones(if_t.D),if_t.D,if_t.Y);
output_c2:assert property (Bit_2) else $error("reset=%0d,valid=%0d,D=%0d,y=%0d",if_t.rst,$countones(if_t.D),if_t.D,if_t.Y);
output_c3:assert property (Bit_3) else $error("reset=%0d,valid=%0d,D=%0d,y=%0d",if_t.rst,$countones(if_t.D),if_t.D,if_t.Y);

rst_check_cover:cover property (rst);
valid_bit_check_cover:cover property (valid_bit);

output_check_cover0:cover property (Bit_0);
output_check_cover1:cover property (Bit_1);
output_check_cover2:cover property (Bit_2);
output_check_cover3:cover property (Bit_3);
endmodule
