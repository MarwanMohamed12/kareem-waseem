import pack_alsu::*;

module ALSU_tb ();
parameter INPUT_PRIORITY = "B";
parameter FULL_ADDER = "ON";

bit  clk=0, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
Opcode_e opcode;
bit signed [2:0] A, B;
bit  [15:0] leds;
bit signed [5:0] out;
bit  [15:0] leds_exp;
bit signed [5:0] out_exp;

//register internal
reg red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
reg signed [1:0] cin_reg;
reg [2:0] opcode_reg; 
reg signed [2:0] A_reg, B_reg; //change to signed



int error =0,correct=0;
bit invalid_t,x1,x2;
bit signed [5:0] last_out=0;

ALSU #(.INPUT_PRIORITY(INPUT_PRIORITY),.FULL_ADDER(FULL_ADDER)) tb (.*);


always #10 clk=!clk;
transaction tr=new();


initial begin
    assert_rst();
    check_rst();

    tr.constraint_mode(0);
    tr.x.constraint_mode(1);
    repeat(300) begin
        assert(tr.randomize());
        init(tr);
        if(rst)begin
            check_rst();
            reset_internal();
	end
        else begin
            check_result();
            sampling(tr);
        end

    end

    tr.constraint_mode(0);
    tr.y.constraint_mode(1);
    rst=0;bypass_A=0;bypass_B=0;red_op_A=0;red_op_B=0;
    tr.rst.rand_mode(0);tr.bypass_A.rand_mode(0);tr.bypass_B.rand_mode(0);tr.red_op_A.rand_mode(0);
    tr.red_op_B.rand_mode(0);
    init(tr);

    for(int i=0;i<1000;i++)begin
        assert(tr.randomize());
        cin=tr.cin;
        direction=direction_reg;
        serial_in=serial_in_reg;
        A=tr.A;
        B=tr.B;
        if('{OR,XOR,ADD,MULT,SHIFT,ROTATE} ==tr.arr)$display("@%0t the wanted sequence is %p",$time,tr.arr);
            foreach(tr.arr[j])begin
                tr.opcode=tr.arr[j];
                opcode=tr.arr[j];
                tr.out=out;
                tr.leds=leds;
                check_result();
                sampling(tr);
            end
    end
    $display("number of correct =%0d ,error=%0d",correct,error);
$stop;

end

task check_result();

    golden_model();
    @(negedge clk);
    if(out_exp!= out && leds_exp != leds)begin
        $display("@%t there is error out=%0b ,leds=%0b " ,$time ,tr.out,tr.leds);error++;
    end
    else
        correct++;


endtask 

task golden_model();                                                                   
    if(is_invalid())
        leds_exp= ~leds_exp;
    else    
        leds_exp=0;
    if(bypass_A_reg && bypass_B_reg)begin
        if (INPUT_PRIORITY== "A")
            out_exp = A_reg;
        else if (INPUT_PRIORITY== "B")
            out_exp = B_reg;
        end
        // check on pypass operations
        else if(bypass_A) //check on bypass
                out_exp = A_reg;
        else if(bypass_B)
                out_exp = B_reg;
        //check on invalid_t condition output
        else if(is_invalid()) begin
                out_exp=0;
        end 
        else begin
            //here we check on OP code
            case (opcode_reg)
            OR:begin// check on priority first
                if(red_op_A_reg && red_op_B_reg && INPUT_PRIORITY== "A")
                    out_exp = A_reg;
                else if(red_op_A_reg && red_op_B_reg&& INPUT_PRIORITY== "B")
                    out_exp = B_reg;
                else if(red_op_A_reg)
                    out_exp = (|A_reg);
                else if(red_op_B_reg)
                    out_exp = (|B_reg);
                else 
                    out_exp = (A_reg|B_reg);
            end 
            XOR:begin
                if(red_op_A_reg && red_op_B_reg && INPUT_PRIORITY== "A")
                    out_exp = A_reg;
                else if(red_op_A_reg && red_op_B_reg&& INPUT_PRIORITY== "B")
                    out_exp = B_reg;
                else if(red_op_A_reg)
                    out_exp = (^A_reg);
                else if(red_op_B_reg)
                    out_exp = (^A_reg);
                else 
                    out_exp = (A_reg^B_reg);
            end
            ADD:begin
                if(FULL_ADDER == "ON")
                    out_exp= A_reg+B_reg+cin_reg;
                else if(FULL_ADDER == "OFF")
                    out_exp= A_reg+B_reg;
            end 
            MULT:begin
                out_exp= A_reg*B_reg;
            end 
            SHIFT:begin
                if(direction_reg)
                    out_exp = {out_exp[4:0],serial_in_reg};
                else if(!direction_reg)
                    out_exp = {serial_in_reg,out_exp[5:1]};
            end
            ROTATE:begin
                if(direction_reg)
                    out_exp = {out_exp[4:0],out_exp[5]};
                else if(!direction_reg)
                    out_exp = {out_exp[0],out_exp[5:1]};
            end 
            endcase

        end
        update_internals();
    endtask

    task update_internals();
        red_op_A_reg=red_op_A; red_op_B_reg=red_op_B; bypass_A_reg=bypass_A;
        bypass_B_reg=bypass_B; direction_reg=direction; serial_in_reg=serial_in;
        cin_reg=cin;
        opcode_reg=opcode; 
        A_reg=A;B_reg=B;  
    endtask

    task assert_rst();
        rst=1;
        @(negedge clk);
        check_rst();
        rst=0;
    endtask

    task check_rst();
        @(negedge clk);
        if(out!=0 || leds!=0)begin
            error++;$display("@$0t there is error on reset",$time);
        end
        else correct++;

        reset_internal();
    endtask

    task reset_internal();
        red_op_A_reg=0; red_op_B_reg=0; bypass_A_reg=0; bypass_B_reg=0; direction_reg=0; serial_in_reg=0;
        cin_reg=0;
        opcode_reg=0; 
        A_reg=0; B_reg=0; //change to signed
    endtask

    function bit is_invalid();
        if(opcode_reg==INVALID6 || opcode_reg==INVALID7)
            return 1;
        else if( (opcode_reg>3'b001) && (red_op_A_reg|red_op_B_reg))
            return 1;
        else    
            return 0;
    endfunction

    function void init(transaction in);
        opcode=tr.opcode;
        A=tr.A;
        B=tr.B;
        rst=tr.rst;
        cin=tr.cin;
        red_op_A=tr.red_op_A;
        red_op_B=tr.red_op_B;
        bypass_A=tr.bypass_A;
        bypass_B=tr.bypass_B; 
        direction=tr.direction; 
        serial_in=tr.serial_in ;
        tr.out=out;
        tr.leds=leds;
    endfunction

    function void sampling(transaction tr);
        if(rst ||bypass_A ||bypass_B)begin
            tr.cvr_gp.stop();
        end
        else begin
            tr.cvr_gp.start();
            tr.cvr_gp.sample();
        end
    endfunction
endmodule