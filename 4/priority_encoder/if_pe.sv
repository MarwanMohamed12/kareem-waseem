interface if_pe(clk);
input bit clk;
logic  rst;
logic  [3:0] D;	
logic  [1:0] Y;
logic  valid;

modport DUT (input clk,rst,D,output Y,valid);
modport TB (output clk,rst,D,input Y,valid);
modport Assertions (input clk,rst,D,output Y,valid);
endinterface 

