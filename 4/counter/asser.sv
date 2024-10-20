module asser(if_counter.Assertions if_t);

property load_check;
@(posedge if_t.clk) disable iff (!if_t.rst_n) (! if_t.load_n  |=> if_t.count_out == $past(if_t.data_load )  );
endproperty

property turn_off_all;
@(posedge if_t.clk) disable iff (!if_t.rst_n) ( (if_t.load_n && !if_t.ce)  |=> $stable(if_t.count_out) );
endproperty

property count_up;
@(posedge if_t.clk) disable iff (!if_t.rst_n) ( (if_t.load_n && if_t.ce &&  if_t.up_down)  |=> if_t.count_out == $past(if_t.count_out) + 1'b1 );
endproperty

property count_down;
@(posedge if_t.clk) disable iff (!if_t.rst_n) ( (if_t.load_n && if_t.ce &&  !if_t.up_down) |=> if_t.count_out == $past(if_t.count_out) - 1'b1 );
endproperty



// immediate assertion
always_comb begin 
    if(!if_t.rst_n)begin
    rst_check:assert final ( if_t.count_out==0 && if_t.zero==1 && if_t.max_count==0 ) ;
    reset_cover:cover (if_t.count_out==0 && if_t.zero==1 && if_t.max_count==0); 
    end
    if(if_t.count_out==0)
    minimum_check:assert(if_t.zero);
    if(if_t.count_out==4'b1111)
    maximum_check:assert(if_t.max_count);


end


//concurent assertion

load_assert:assert property(load_check) ;
turn_off_all_assert:assert property(turn_off_all);
count_up_assert:assert property(count_up);
count_down_assert:assert property(count_down);


//coverage assertion
load_cover:cover property(load_check);
turn_off_all_cover:cover property(turn_off_all);
count_up_cover:cover property(count_up);
count_down_cover:cover property(count_down);

endmodule
