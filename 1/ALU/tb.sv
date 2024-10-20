module tb();

logic clk;
logic reset;
logic  [1:0] Opcode;	// The opcode
logic signed [3:0] A;	// Input data A in 2's complement
logic signed [3:0] B;	// Input data B in 2's complement
logic signed [4:0] C;    // ALU output in 2's complement

int error=0,correct=0;
localparam MAXPOS=7,MAXNEG=-8,ZERO=0;
localparam Add = 2'b00,Sub = 2'b01,Not_A= 2'b10,ReductionOR_B = 2'b11; 

ALU_4_bit T1(.*);
initial begin
clk=0;
forever #5 clk=!clk;
end

initial begin
Opcode=ZERO;
A=ZERO;
B=ZERO;
call_reset;

Opcode=Add;//
A=MAXPOS;
B=MAXNEG;
checker_res(-1);

Opcode=Sub;
checker_res(15);

Opcode=Add;
A=MAXPOS;
B=MAXPOS;
checker_res(14);

Opcode=Sub;
checker_res(0);

Opcode=Add;
A=MAXNEG;
B=MAXNEG;
checker_res(-16);

Opcode=Sub;
checker_res(0);

Opcode=Add;
A=MAXNEG;
B=MAXPOS;
checker_res(-1);

Opcode=Sub;
checker_res(-15);

Opcode=Add;
A=ZERO;
B=MAXNEG;
checker_res(-8);

Opcode=Sub;
checker_res(8);

Opcode=Add;
A=ZERO;
B=MAXPOS;
checker_res(7);

Opcode=Sub;
checker_res(-7);

Opcode=Add;
A=MAXPOS;
B=ZERO;
checker_res(7);

Opcode=Sub;
checker_res(7);

Opcode=Add;
A=MAXNEG;
B=ZERO;
checker_res(-8);

Opcode=Sub;
checker_res(-8);

Opcode=Add;
A=ZERO;
B=ZERO;
checker_res(0);

Opcode=Sub;
checker_res(0);

Opcode=Not_A;
A=ZERO;
checker_res(-1);

A=-1;
checker_res(ZERO);

A=MAXNEG;
checker_res(MAXPOS);

A=MAXPOS;
checker_res(MAXNEG);

Opcode=ReductionOR_B;
B=ZERO;
checker_res(ZERO);

B=MAXPOS;
checker_res(1);

B=MAXNEG;
checker_res(1);

B=-1;
checker_res(1);

B=1;
checker_res(1);

reset=1;
Opcode=Add;
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