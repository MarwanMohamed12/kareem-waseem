module priority_enc_tb();

logic clk;
logic rst;
logic [3:0] D;
logic [1:0] Y;
logic valid;


int correct=0 ,wrong=0,i=0,j=0;
priority_enc p1(.*);

initial begin
clk=0;
forever #5 clk=!clk;
end

initial begin
for(j=0;j<2;j++)
begin
reset_call(!j);
    for(i=0;i<16;i++)
    begin
	if(rst)
	  check_correctness(0);
	else begin
	  D=i;
	  if(D[0]==1'b1)
		check_correctness(7);
	  else if(D[1]==1'b1)
		check_correctness(5);
	  else if(D[2]==1'b1)
		check_correctness(3);
	  else if(D[3]==1'b1)
		check_correctness(1);
	  else
		check_correctness(0);
	end
    end
end
D=0;
check_correctness(0);

reset_call(1);
check_correctness(0);

$display("error_count=%0d  ------- correct_count=%0d",wrong,correct);
$stop;
end

task check_correctness(input logic [2:0]value);
@(negedge clk);
if(rst && (value[2:1] !=Y))begin
	$display("there is somthing wrong @%t the number %0d",$time,{Y,valid});
	wrong++;
	end
else if(rst==0 && D >0 && value!={Y,valid})begin
	$display("there is somthing wrong @%t the number %0d",$time,{Y,valid});
	wrong++;
	end
else if(rst==0 && D==0 && value[0]!= valid)begin
	$display("there is somthing wrong @%t the number %0d",$time,{Y,valid});
	wrong++;
	end
else
	correct++;


endtask

task reset_call(input bit turn_on);
if(turn_on)
	rst=1;
else
	rst=0;
endtask

endmodule
