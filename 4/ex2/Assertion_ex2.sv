module Assertion_ex2 ();
logic a,b,c,valid;
logic [3:0]d;
bit clk=0;
logic[7:0]Y;

always #100 clk=!clk;

property x1;
    @(posedge clk)(a |-> ##2 b);
endproperty

property x2;
@(posedge clk)(a && b |-> ##[1:3] c);
endproperty

sequence s11b;
##2 !b;
endsequence

property x3;
@(posedge clk) s11b;
endproperty

property x4;
@(posedge clk) $onehot(Y);
endproperty

property x5;
@(posedge clk) ($countones(d)==0 |-> ##1 !valid);

endproperty
a1:assert property(x1) ;
a1_c:cover property(x1);

a2:assert property(x2) ;
a2_c:cover property(x2);

a3:assert property(x3) ;
a3_c:cover property(x3);

a4:assert property(x4) ;
a4_c:cover property(x4);

a5:assert property(x5) ;
a5_c:cover property(x5);

initial begin
    a=1;b=0;c=0;Y='d1;
    repeat(2)@(negedge clk);
    a=1;b=1;
    repeat(2)@(negedge clk);
    c=1;Y=0;d=4'b0000;valid=1;
    repeat(2)@(negedge clk);
    valid=0;
    repeat(2)@(negedge clk);
    $stop;
end
endmodule
