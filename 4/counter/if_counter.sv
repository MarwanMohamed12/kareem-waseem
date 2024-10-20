interface if_counter(clk);



parameter WIDTH = 4;

//input bit clk;
input bit clk;


logic rst_n,load_n,up_down,ce;
logic  [WIDTH-1:0] data_load;
logic  [WIDTH-1:0] count_out;
logic max_count,zero;


modport DUT (input clk,rst_n,load_n,up_down,ce,data_load,output max_count,zero,count_out);
modport TEST (output rst_n,load_n,up_down,ce,data_load,input clk,max_count,zero,count_out);
modport Assertions (input clk,rst_n,load_n,up_down,ce,data_load,output max_count,zero,count_out);

endinterface
