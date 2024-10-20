
module Asser(if_d.Assertionss if_t);

always_comb begin 
    if(if_t.reset)
      a_reset:assert final(if_t.C==0);
end

 
property addition_check;
  @(posedge if_t.clk) disable iff (if_t.reset) 
    (if_t.Opcode ==if_t.Add) |=> (if_t.C == $past(if_t.A) + $past(if_t.B) );
endproperty


property subtraction_check;
 @(posedge if_t.clk) disable iff (if_t.reset)  
    (if_t.Opcode==if_t.Sub) |=>  ( if_t.C == $past(if_t.A) - $past(if_t.B) );
endproperty

property NotA_check;
@(posedge if_t.clk) disable iff (if_t.reset)  ( if_t.Opcode == if_t.Not_A ) |=>( if_t.C == ~ $past(if_t.A) ) ;
endproperty

property ReductionOR_B_check;
@(posedge if_t.clk) disable iff (if_t.reset)  (if_t.Opcode==if_t.ReductionOR_B) |=> (if_t.C== |$past(if_t.B));
endproperty




addition:assert property(addition_check)else $error("reset=%0d ,Opcode=%0d,A=%0d ,B=%0d ,c=%0d ",if_t.reset,if_t.Opcode,if_t.A,if_t.B
                                                                                            ,if_t.C);
addition_co:cover property(addition_check);

subtraction:assert property(subtraction_check)else $error("reset=%0d ,Opcode=%0d,A=%0d ,B=%0d ,c=%0d ",if_t.reset,if_t.Opcode,if_t.A,if_t.B
                                                                                            ,if_t.C);
subtraction_co:cover property(subtraction_check);

not_ch:assert property(NotA_check)else $error("reset=%0d ,Opcode=%0d,A=%0d ,B=%0d ,c=%0d ",if_t.reset,if_t.Opcode,if_t.A,if_t.B
                                                                                      ,if_t.C);
not_ch_co:cover property(NotA_check);

oring:assert property(ReductionOR_B_check)else $error("reset=%0d ,Opcode=%0d,A=%0d ,B=%0d ,c=%0d ",if_t.reset,if_t.Opcode,if_t.A,if_t.B
                                                                                             ,if_t.C);
oring_co:cover property(ReductionOR_B_check);

endmodule