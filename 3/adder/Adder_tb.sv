import pack::*;

module Adder_tb();

int correct,error;
bit  clk,reset;
logic  signed [3:0] A;	// Input data A in 2's complement
logic  signed [3:0] B;	// Input data B in 2's complement
logic signed [4:0] C;

adder tb1(.*);

transaction tr=new();

initial 
begin clk=0;
forever #5 clk=!clk;
tr.clk=clk;
end


initial begin 
tr.reset=1;
init(tr);
checker_res(tr);
sampling(tr);

repeat(15)begin
assert(tr.randomize());
init(tr);
checker_res(tr);
sampling(tr);
end
$display("error_count=%0d  ------- correct_count=%0d",error,correct);
$stop;

end 

task checker_res(transaction tr);
golden_model(tr);
@(negedge clk);
if(C!=tr.C)begin
$display("there is somthing wrong @%t",$time);
error++;
end
else 
correct++;
endtask

task golden_model(transaction tr);
if(tr.reset)
    tr.C=0;
else
    tr.C=tr.A+tr.B;
endtask

 

function void init(transaction tx);
A=tx.A;B=tx.B;
reset=tx.reset;
tx.C=C;
endfunction

function void sampling(transaction ts);
if(ts.reset)begin
//$display("@%0t im  done1");
ts.Covgrp_A.stop();
ts.Covgrp_B.stop();
end
else begin
//$display("@%0t im  done1");
ts.Covgrp_A.start();
ts.Covgrp_B.start();
ts.Covgrp_A.sample();
ts.Covgrp_B.sample();
end


endfunction


endmodule
