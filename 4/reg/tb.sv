typedef enum logic[2:0]{adc0_reg=0,adc1_reg,temp_sensor0_reg,temp_sensor1_reg,analog_test,digital_test,amp_gain,digital_config } reg_values_e;
logic [15:0] reset_assoc[string];
int error=0,correct=0;
logic [15:0] exp_out;
module tb;

bit clk=0;
logic reset;
logic write;
logic [15:0] data_in;
logic [2:0] address;
logic [15:0] data_out;

reg_values_e reg_e;

config_reg TB(.*);

always #100 clk=!clk;

initial begin
    /*reset=0;
    writing(temp_sensor1_reg,16'hffff);
    @(negedge clk);
    reading(temp_sensor1_reg);
    check_result();
*/
	reg_e=reg_e.first();

    assert_rst();

    @(negedge clk);
    //writing
    reg_e=reg_e.first();
    for(int x=0 ; x<reg_e.num ; x++ )begin
        writing(reg_e,x+45);
        reg_e=reg_e.next();
        @(negedge clk);
    end
    //reading
    reg_e=reg_e.first();
    for(int x=0 ; x<reg_e.num() ; x++ )begin
        reading(reg_e);
        check_result();
        reg_e=reg_e.next();
    end
    
    writing(temp_sensor1_reg,16'hffff);
    @(negedge clk);
    writing(digital_config,16'hffff);
    @(negedge clk);
    reading(temp_sensor1_reg);
    check_result();
    reading(digital_config);
    check_result();

    assert_rst();

 

    $display("errors = %0d ,correct = %0d 0",error,correct);
    $stop;
end

task golden_model();
    reset_assoc["adc0_reg"]=16'hffff ;
    reset_assoc["adc1_reg"]=16'h0 ;
    reset_assoc["temp_sensor0_reg"]=16'h0 ;
    reset_assoc["temp_sensor1_reg"]=16'h0 ;
    reset_assoc["analog_test"]=16'hABCD ;
    reset_assoc["digital_test"]=16'h0 ;
    reset_assoc["amp_gain"]=16'h0 ;
    reset_assoc["digital_config"]=16'h1 ;
endtask

task assert_rst();
reset=1;
golden_model();
check_result();
reset=0;
endtask


task check_rst();
reg_e=reg_e.first();
for(int i=0 ; i<reg_e.num ; i++ )begin
address=i;
@(negedge clk);
if(reset_assoc[reg_e.name] != data_out)begin
    $display("@%0t there is error on reset reg=%s .. expect=%0h ,found=%0h",$time,reg_e.name,reset_assoc[reg_e.name],data_out);
    error++;
end 
else begin 
   correct++;
   
end
reg_e=reg_e.next();
end
endtask

task check_result();

if(reset)
check_rst();
else begin
    @(negedge clk);
    if(write==0 && exp_out != data_out)begin
        $display("@%0t there is error on reg=%s .. expect=%0h ,found=%0h",$time,reg_e.name,exp_out,data_out);
        error++;
    end 
    else begin 
        correct++;
    end
end


endtask

function void writing(reg_values_e address_t,bit [15:0] data_t);
write=1;
address=address_t;
data_in=data_t;
reset_assoc[address_t.name]=data_t;
endfunction

function bit [15:0] reading(reg_values_e address_t);
write=0;
address=address_t;
exp_out=reset_assoc[address_t.name];
endfunction

endmodule


