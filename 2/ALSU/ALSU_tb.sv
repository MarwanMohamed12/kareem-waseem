package pack_alsu;
typedef enum { OR=0,XOR,ADD,MULT,SHIFT,ROTATE,INVALID6,INVALID7 } Opcode_e;
typedef enum {MAXPOS=3,MAXNEG=-4,ZERO=0}corner_state_e;

class transaction;
    rand bit  clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    rand Opcode_e opcode;
    rand bit signed [2:0] A, B;
    bit [2:0] ones_number={3'b001,3'b010,3'b100};
    rand bit [2:0] found,notfound;
    rand corner_state_e a_state;
    rand bit [2:0] rem_numbers;
    
   
    constraint trans {

       rem_numbers!= MAXPOS||MAXNEG||ZERO;

        rst dist {1:=5 , 0:=95};

        found inside {ones_number};
        !(notfound inside {ones_number});

        if (opcode ==ADD || opcode== MULT){
            A dist {a_state:=80,rem_numbers:=20};
            B dist {a_state:=80,rem_numbers:=20};
        }
        if ((opcode ==OR || opcode== XOR ) && red_op_A==1'b1){
            A dist {found:=80,notfound:=20};
            B==3'b000;
        }
        else if ((opcode ==OR || opcode== XOR ) && red_op_B==1'b1){
            B dist {found:=80,notfound:=20};
            A==3'b000;
        }

        opcode dist {[OR:ROTATE]:=80,[INVALID6:INVALID7]};

        bypass_A dist {0:=90,1:=10};
        bypass_B dist {0:=90,1:=10};
        if(opcode ==OR ||opcode ==XOR ){
        red_op_A && red_op_B dist {1:=70,0:=30};
        }
    }
endclass 
endpackage


import pack_alsu::*;

module ALSU_tb ();
parameter INPUT_PRIORITY = "B";
parameter FULL_ADDER = "ON";

bit  clk=0, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
bit [2:0] opcode;
bit signed [2:0] A, B;
bit  [15:0] leds;
bit signed [5:0] out;

Opcode_e kind;
int errors =0,correct=0;
bit invalid;
bit signed [5:0] last_out=0;

ALSU #(.INPUT_PRIORITY(INPUT_PRIORITY),.FULL_ADDER(FULL_ADDER)) tb (.*);


always #10 clk=!clk;
transaction tr=new();


initial begin
    tr.rst=1'b1;
    rst=tr.rst;
    test();
    repeat(20) begin
        assert(tr.randomize());
        opcode=tr.opcode;A=tr.A;B=tr.B;
        rst=tr.rst;cin=tr.cin; red_op_A=tr.red_op_A; red_op_B=tr.red_op_B; bypass_A=tr.bypass_A;
        bypass_B=tr.bypass_B; direction=tr.direction; serial_in=tr.serial_in ;
        test();
    end

        opcode=SHIFT;
        bypass_A=0;bypass_B=0;red_op_A=0;red_op_B=0;rst=0;
        test();
	    opcode=ROTATE;
        bypass_A=0;bypass_B=0;red_op_A=0;red_op_B=0;rst=0;
        test();
        /*opcode=tr.opcode;A=tr.A;B=tr.B;
        rst=tr.rst;cin=tr.cin; red_op_A=tr.red_op_A; red_op_B=tr.red_op_B; bypass_A=tr.bypass_A;
        bypass_B=tr.bypass_B; direction=tr.direction; serial_in=tr.serial_in ;*/
        

    $display("number of correct =%0d ,error=%0d",correct,errors);
$finish;

end

task  test();
    
  
    repeat (2) @(negedge clk);

      invalid=(opcode==INVALID6 || opcode == INVALID7)                                                                     
            || ((red_op_A==1'b1 | red_op_B==1'b1) && (opcode!= OR | opcode!=XOR));
    
    // check on led
    if(invalid && leds!=leds)begin
        $display("@%0t you have problem in led toggle",$time); errors++;
    end
    else if(!invalid && leds!=0)begin
        $display("@%0t you have problem in led zero",$time);   errors++;
    end

    // check output -out
    if(rst)begin //check on reset
        if(rst && out !=0 && leds !=0)begin
            $display("@%0t you have problem in reset",$time); errors++;
        end
        else correct++;

    end
    else begin
        // check on priority case on bypass
        if(bypass_A && bypass_B)begin
            if (bypass_A ==1 && bypass_B ==1 && out != A && INPUT_PRIORITY== "A") begin
                $display("@%0t you have problem priority A",$time); errors++;
            end
            else if (bypass_A ==1 && bypass_B ==1 && out != B && INPUT_PRIORITY== "B") begin
                $display("@%0t you have problem priority B",$time); errors++;
            end
            else correct++;
        end
        // check on pypass operations
        else if(bypass_A | bypass_B)begin //check on bypass
            if(bypass_A ==1 && out != A)begin
                $display("@%0t you have problem bypass A",$time); errors++;
            end
            else if(bypass_B ==1 && out != B)begin
                $display("@%0t you have problem bypass B",$time); errors++;
            end
            else correct++;
        end
        //check on invalid condition output
        else if(invalid) begin
            if (invalid ==1 && out!= 0 && leds!= leds)begin
                $display("@%0t you have problem in invalid ",$time); errors++;
            end
            else correct++;
        end 
        else begin
            //here we check on OP code
            case (opcode)
            OR:begin// check on priority first
                if(red_op_A==1 && red_op_B==1 && out != A && INPUT_PRIORITY== "A")begin
                    $display("@%0t you have problem priority A",$time); errors++;
                end
                else if(red_op_A==1 && red_op_B==1 && out != B && INPUT_PRIORITY== "B")begin
                    $display("@%0t you have problem priority B",$time); errors++;
                end
                else if(red_op_A==1 && out != (|A))begin
                    $display("@%0t you have problem in OR _red_A ",$time); errors++;
                end
                else if(red_op_B==1 && out != (|B))begin
                    $display("@%0t you have problem in OR _red_B ",$time); errors++;
                end
                else if(red_op_A==0 && red_op_B==0 && out != (A|B))begin
                    $display("@%0t you have problem in OR A|B ",$time); errors++;
                end
                else correct++;
            end 
            XOR:begin
                if(red_op_A==1 && red_op_B==1 && out != A && INPUT_PRIORITY== "A")begin
                    $display("@%0t you have problem priority A",$time); errors++;
                end
                else if(red_op_A==1 && red_op_B==1 && out != B && INPUT_PRIORITY== "B")begin
                    $display("@%0t you have problem priority B",$time); errors++;
                end
                else if(red_op_A==1 && out != (^A))begin
                    $display("@%0t you have problem in XOR _red_A ",$time); errors++;
                end
                else if(red_op_B==1 && out != (^B))begin
                    $display("@%0t you have problem in XOR _red_B ",$time); errors++;
                end
                else if(red_op_A==0 && red_op_B==0 && out != (A^B))begin
                    $display("@%0t you have problem in XOR A^B ",$time); errors++;
                end
                else correct++;
            end
            ADD:begin
                if(FULL_ADDER == "ON" && out!= A+B+cin)begin
                    $display("@%0t you have problem in ADDER with full adder ",$time); errors++;
                end
                else if(FULL_ADDER == "OFF" && out!= A+B)begin
                    $display("@%0t you have problem in ADDER  ",$time); errors++;
                end
                else correct++;
            end 
            MULT:begin
                if(out!= A*B)begin
                    $display("@%0t you have problem ADDER with full adder ",$time); errors++;
                end
                else correct++;
            end 
            SHIFT:begin
                if(direction==1 && out != {last_out[4:0],serial_in})begin
                    $display("@%0t you have problem in shift left ",$time); errors++;
                end
                else if(direction==0 && out != {serial_in,last_out[5:1]})begin
                    $display("@%0t you have problem in shift right ",$time); errors++;
                end
                else correct++;
            end
            ROTATE:begin
                if(direction==1 && out != {last_out[4:0],last_out[5]})begin
                    $display("@%0t you have problem in rotate left ",$time); errors++;
                end
                else if(direction==0 && out != {last_out[0],last_out[5:1]})begin
                    $display("@%0t you have problem in rotate right ",$time); errors++;
                end
                else correct++;
            end 
            endcase

        end

    end
    last_out=out;

endtask 

endmodule