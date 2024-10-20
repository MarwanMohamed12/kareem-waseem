
interface if_d(clk);
input bit clk;
logic reset;
logic [1:0]Opcode;
logic signed [3:0] A;	
logic signed [3:0] B;	
logic signed [4:0] C;


localparam   Add	           = 2'b00; // A + B
localparam 	 Sub	           = 2'b01; // A - B
localparam 	 Not_A	           = 2'b10; // ~A
localparam 	 ReductionOR_B     = 2'b11; // |B


modport DUT (input clk,reset,Opcode,A,B,output C);
modport TB (output clk,reset,Opcode,A,B,input C);
modport Assertionss (input clk,reset,Opcode,A,B,output C);
endinterface 
