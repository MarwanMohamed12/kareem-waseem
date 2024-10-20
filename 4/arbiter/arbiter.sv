module arbiter();
logic request,grant,frame,irdy;



always #100 clk=!clk;

property prop_1;
    @(posedge clk)($rose(request) |-> ##[2:5] $rose(grant) );
endproperty

property prop_2;
@(posedge clk)( $rose(grant) |-> $fell(frame && irdy) );
endproperty

property prop_3;
@(posedge clk)  ( $rose(frame && irdy) |=> $fell(grant) );
endproperty

a1:assert property(prop_1) ;
a1_c:cover property(prop_1);
a2:assert property(prop_2) ;
a2_c:cover property(prop_2);
a3:assert property(prop_3) ;
a3_c:cover property(prop_3);

initial begin

    $stop;
end
endmodule
