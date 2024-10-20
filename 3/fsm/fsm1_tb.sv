import pack::*;

module fsm1_tb ();

	bit clk=0, rst, x;
	bit y;
	bit [9:0] users_count;

    int correct=0,error=0;

FSM_010 tb(.*);

fsm_transaction tr=new();

initial begin
    forever begin
        #5 clk=!clk;
        tr.clk=clk;
    end
end



initial begin
 
    rst=1;
    check_result(tr);
    repeat(60)begin
        assert(tr.randomize());
        rst=tr.rst;x=tr.x;
        tr.y_exp=y;
        check_result(tr);
    end
    $display("correct=%0d ,error=%0d",correct,error);
$stop;
end



task check_result(fsm_transaction tr);

    golden_model(tr);
    @(negedge clk);
    if(tr.y_exp!=y || tr.user_count_exp != users_count)begin
        $display("@%t there error which tr.y_exp=%0d ,y=%0d",$time,tr.y_exp,y);error++;
    end
    else correct++;
endtask

task golden_model(fsm_transaction tr);
        static state_e ps, ns;
        tr.check=ps;
            case (ps)
                Idle: begin

                    if (tr.x) ns = Idle;
                    else ns = zero;
                end 
                zero: begin

                    if (tr.x) ns = one;
                    else ns = zero;
                end 
                one: begin

                    if (tr.x) ns = Idle;
                    else ns = Store;
                end 
                Store: begin
                    if (tr.x) ns = Idle;
                    else ns = zero;
                end 
            endcase
        
            @(posedge clk);
            if (tr.rst) begin
                tr.y_exp <= 0;
                tr.user_count_exp <= 0;
                ps <= Idle;
                ns <= zero;
            end 
            else begin
                ps=ns;
                if (ps==Store)begin
                    tr.y_exp <= 1;
                    tr.user_count_exp=tr.user_count_exp+1;
                end   
            end
    endtask


endmodule
