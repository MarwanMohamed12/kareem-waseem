import pack::*;
module counter_tb(if_counter if_t);

transaction tr=new();

always_comb begin tr.clk=if_t.clk; end

initial begin

    if_t.rst_n=0;
    @(negedge if_t.clk);
    repeat(200)begin
        assert (tr.randomize());
	    if_t.rst_n=tr.rst_n;
        if_t.load_n=tr.load_n;
        if_t.up_down=tr.up_down;
        if_t.ce=tr.ce;
        if_t.data_load=tr.data_load ;
        tr.count_out=if_t.count_out;
        tr.max_count=if_t.max_count;
        tr.zero=if_t.zero;
        @(negedge if_t.clk);#1;
    end

$stop;
end
endmodule
