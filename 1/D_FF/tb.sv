module tb_1();

parameter USE_EN = 1;
logic clk=0, rst, d, en;
logic q;

int correct=0,error=0;
always #5 clk=~clk;

dff #(.USE_EN(USE_EN)) DUT(.*);

initial begin
d=0;
en=0;
call_reset;
d=0;
en=0;
check_resul(q);
d=1;
en=1;
check_resul(1);
d=1;
en=0;
check_resul(q);
d=0;
en=1;
check_resul(0);
call_reset;
$display("error_count=%0d  ------- correct_count=%0d",error,correct);
$stop;
end

task check_resul(input logic check_result);
@(negedge clk);
if(check_result!=q)begin
$display("there is somthing wrong @%t  check_result =%0d   q=%0d  ",$time,check_result,q);
error++;
end
else 
correct++;

endtask

task call_reset;
rst=1;
check_resul(0);
rst=0;
endtask


endmodule
