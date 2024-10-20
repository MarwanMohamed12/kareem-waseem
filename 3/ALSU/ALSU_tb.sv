import pack_alsu::*;

module ALSU_tb ();
parameter INPUT_PRIORITY = "B";
parameter FULL_ADDER = "ON";

bit  clk=0, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
Opcode_e opcode;
bit signed [2:0] A, B;
bit  [15:0] leds;
bit signed [5:0] out;



int error =0,correct=0;
bit invalid_t,x1,x2;
bit signed [5:0] last_out=0;

ALSU #(.INPUT_PRIORITY(INPUT_PRIORITY),.FULL_ADDER(FULL_ADDER)) tb (.*);


always #10 clk=!clk;
transaction tr=new();


initial begin
    tr.rst=1'b1;
    init(tr);
    check_result(tr);

    tr.constraint_mode(0);
    tr.x.constraint_mode(1);
    repeat(200) begin
        assert(tr.randomize());
        init(tr);
        check_result(tr);
        sampling(tr);
    end

    tr.constraint_mode(0);
    tr.y.constraint_mode(1);
    tr.rst=0;tr.bypass_A=0;tr.bypass_B=0;tr.red_op_A=0;tr.red_op_B=0;
    tr.rst.rand_mode(0);tr.bypass_A.rand_mode(0);tr.bypass_B.rand_mode(0);tr.red_op_A.rand_mode(0);
    tr.red_op_B.rand_mode(0);
    init(tr);

    for(int i=0;i<100;i++)begin
        assert(tr.randomize());
        cin=tr.cin;direction=tr.direction;serial_in=tr.serial_in;A=tr.A;B=tr.B;
        if('{OR,XOR,ADD,MULT,SHIFT,ROTATE} ==tr.arr)$display("@%0t the wanted sequence is %p",$time,tr.arr);
        foreach(tr.arr[j])begin
          
            tr.opcode=tr.arr[j];
            opcode=tr.arr[j];
            tr.out=out;
            tr.leds=leds;
            check_result(tr);
            sampling(tr);
        end
    end
    $display("number of correct =%0d ,error=%0d",correct,error);
$stop;

end

task check_result(input transaction  ch);

    golden_model(ch);
       repeat(2) @(negedge clk);
        if(ch.out != out && ch.leds != leds)begin
            $display("@%t there is error out=%0b ,leds=%0b " ,$time ,tr.out,tr.leds);error++;
        end
        else
            correct++;

    if(ch.opcode ==ROTATE || ch.opcode ==SHIFT)begin
        golden_model(ch);
    end

endtask 


task golden_model(input transaction  tr);
        x1=tr.opcode==INVALID6 || tr.opcode == INVALID7;
        x2=(tr.red_op_A==1'b1 | tr.red_op_B==1'b1) && (tr.opcode!= OR && tr.opcode!=XOR);
        invalid_t= x1 || x2;                                                             
            
    if(invalid_t)
        tr.leds= ~tr.leds;
        
    if(tr.rst)begin //check on reset
        tr.out=0;
        tr.leds= 0;
    end
    else begin
        if(tr.bypass_A && tr.bypass_B)begin
            if (INPUT_PRIORITY== "A")
                tr.out = tr.A;
            else if (INPUT_PRIORITY== "B")
                tr.out = tr.B;
        end
        // check on pypass operations
        else if(bypass_A) //check on bypass
                tr.out = tr.A;
        else if(bypass_B)
                tr.out = tr.B;
        //check on invalid_t condition output
        else if(invalid_t) begin
                tr.out=0;
        end 
        else begin
            //here we check on OP code
            case (tr.opcode)
            OR:begin// check on priority first
                if(tr.red_op_A && tr.red_op_B && INPUT_PRIORITY== "A")
                    tr.out = tr.A;
                else if(tr.red_op_A && tr.red_op_B&& INPUT_PRIORITY== "B")
                    tr.out = tr.B;
                else if(tr.red_op_A)
                    tr.out = (|tr.A);
                else if(tr.red_op_B)
                    tr.out = (|tr.B);
                else 
                    tr.out = (tr.A|tr.B);
            end 
            XOR:begin
                if(tr.red_op_A && tr.red_op_B && INPUT_PRIORITY== "A")
                    tr.out = tr.A;
                else if(tr.red_op_A && tr.red_op_B&& INPUT_PRIORITY== "B")
                    tr.out = tr.B;
                else if(tr.red_op_A)
                    tr.out = (^tr.A);
                else if(tr.red_op_B)
                    tr.out = (^tr.B);
                else 
                    tr.out = (tr.A^tr.B);
            end
            ADD:begin
                if(FULL_ADDER == "ON")
                    tr.out= tr.A+tr.B+tr.cin;
                else if(FULL_ADDER == "OFF")
                    tr.out= tr.A+tr.B;
            end 
            MULT:begin
                tr.out= tr.A*tr.B;
            end 
            SHIFT:begin
                if(tr.direction)
                    tr.out = {tr.out[4:0],tr.serial_in};
                else if(!tr.direction)
                    tr.out = {tr.serial_in,tr.out[5:1]};
            end
            ROTATE:begin
                if(tr.direction)
                    tr.out = {tr.out[4:0],tr.out[5]};
                else if(!tr.direction)
                    tr.out = {tr.out[0],tr.out[5:1]};
            end 
            endcase

        end

    end
    last_out=tr.out;
    endtask

    function void init(transaction in);
        opcode=tr.opcode;A=tr.A;B=tr.B;
        rst=tr.rst;cin=tr.cin; red_op_A=tr.red_op_A; red_op_B=tr.red_op_B; bypass_A=tr.bypass_A;
        bypass_B=tr.bypass_B; direction=tr.direction; serial_in=tr.serial_in ;
        tr.out=out;tr.leds=leds;
    endfunction

    function sampling(transaction tr);
        if(rst ||bypass_A ||bypass_B)begin
            tr.cvr_gp.stop();
        end
        else begin
            tr.cvr_gp.start();
            tr.cvr_gp.sample();
        end
    endfunction
endmodule