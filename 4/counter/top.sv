
module top();

bit clk=0;

initial begin
forever 
    begin
        #100 clk =!clk; 
    end  
end


if_counter if_t(clk);
counter dut(if_t);
counter_tb tb(if_t);
bind counter asser SVA(if_t);

endmodule