module tb();

localparam MAXPOS=7,MAXNEG=-8,ZERO=0;//when we used too much we should make as param
int correct,error;
bit  clk,reset;
logic  signed [3:0] A;	// Input data A in 2's complement
logic  signed [3:0] B;	// Input data B in 2's complement
logic signed [4:0] C;

adder tb1(.*);
initial 
begin clk=0;
forever #5 clk=!clk;
end

initial begin 
call_reset;

A=MAXPOS;
B=MAXNEG;
checker_res(-1);

A=MAXPOS;
B=MAXPOS;
checker_res(14);

A=MAXNEG;
B=MAXNEG;
checker_res(-16);

A=MAXNEG;
B=MAXPOS;
checker_res(-1);

A=ZERO;
B=MAXNEG;
checker_res(-8);

A=ZERO;
B=MAXPOS;
checker_res(7);

A=MAXPOS;
B=ZERO;
checker_res(7);

A=MAXNEG;
B=ZERO;
checker_res(-8);

A=ZERO;
B=ZERO;
checker_res(0);

reset=1;
checker_res(0);

$display("error_count=%0d  ------- correct_count=%0d",error,correct);
$stop;

end 

task checker_res(input logic signed[4:0] check_result);
@(negedge clk);
if(check_result!=C)begin
$display("there is somthing wrong @%t",$time);
error++;
end
else 
correct++;

endtask

task call_reset;
reset=1;
checker_res(0);
reset=0;
endtask

endmodule
