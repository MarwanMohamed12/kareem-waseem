import pack_file::*;

module ALU_tb ();

bit clk=0;
bit reset;
bit [1:0] Opcode;	// The opcode
bit signed [3:0] A;	// Input data A in 2's complement
bit signed [3:0] B;	// Input data B in 2's complement
    
bit signed [4:0] C,c_check; // ALU output in 2's complement

int correct=0,error=0;


ALU_4_bit tb(.*);

always #5 clk =!clk;
transaction tr=new();


initial begin
    
    reset=1;
    check_result();
    repeat(50) begin
        assert(tr.randomize());
        reset=tr.reset;Opcode=tr.Opcode;A=tr.A;B=tr.B;
        check_result();
    end
    $display("number of error=%0d , number of correct=%0d",error,correct);
$finish;
end


task  check_result();
	@(negedge clk);
    if(reset)begin
        if(reset && C!=0)begin
            $display("@%0t there an error ",$time); error++;
        end
        else begin
        correct++;
        end
    end
    else begin
        case (Opcode)
        Add:begin
            if(C!=A+B)begin
                $display("@%0t there an error in Addition ",$time); error++;
            end  
            else correct++;
        end
        Sub:begin
            if(C!=A-B)begin
                $display("@%0t there an error in subtraction ",$time); error++;
            end  
            else correct++;
        end
        Not_A:begin
            if(C!=(~A))begin
                $display("@%0t there an error in not A ",$time); error++;
            end  
            else correct++;
        end
        ReductionOR_B:begin
           if(C!=(|B))begin
                $display("@%0t there an error in OR B ",$time); error++;
            end  
            else correct++;
        end 
        endcase

    end
   

    


endtask  

endmodule
