module tb();

parameter OPERATION = "ADD";
logic  [17:0] A, B, D;
logic  [47:0] C;
logic clk, rst_n;
logic  [47:0] P;


int error=0,correct=0;

initial begin
    clk=0;
    forever #5 clk=!clk;
end

DSP D1(.*);

initial begin
A=0;
B=0;
C=0;
D=0;
call_rst_n;

for(int i=0;i<20;i++)begin
    A=$random;
    B=$random;
    C=$random;
    D=$random;
    
    checker_res(((D+B)*A)+C);
end

call_rst_n;
$display("error_count=%0d  ------- correct_count=%0d",error,correct);
$stop;

end


task checker_res(input logic signed[47:0] check_result);
repeat(5) @(negedge clk);
if(check_result!=P)begin
$display("there is somthing wrong @%t",$time);
error++;
end
else 
correct++;

endtask

task call_rst_n;
rst_n=0;
checker_res(0);
rst_n=1;
endtask

endmodule
