import all_item::*;

int error=0,correct =0;

module counter_tb();

parameter WIDTH = 4;

logic clk=1,rst_n,load_n,up_down,ce;
logic  [WIDTH-1:0] data_load;
logic  [WIDTH-1:0] count_out;
logic max_count,zero;
bit[3:0] last_value=0;

counter #(.WIDTH(WIDTH)) co (.*);

initial begin
forever begin#5 clk=!clk;
tr.clk=clk;
end
end

transaction tr=new();

initial begin
    tr.rst_n=0; rst_n=tr.rst_n;
    check_result(tr);
    repeat(500)begin
        assert (tr.randomize() );
	    rst_n=tr.rst_n;
        load_n=tr.load_n;
        up_down=tr.up_down;
        ce=tr.ce;
        data_load=tr.data_load ;
        tr.count_out=count_out;
        check_result(tr);


    end
    $display("number of correct =%0d ,error=%0d",correct,error);
$finish;
end

task check_result(input transaction trans);
    //check reset
    golden_model(trans);
    @(negedge clk);
    if(trans.count_out!=count_out || trans.zero!=zero || trans.max_count!=max_count)begin
        $display("@%0t there is error count=%0d , zero=%0d ,max_count=%0d",$time,trans.count_out,trans.zero,trans.max_count);
        error++;
    end
    else 
        correct++;

endtask

task golden_model(input transaction tr_task);

if(!tr_task.rst_n)
tr_task.count_out=0;
else if(!load_n)
tr_task.count_out=tr_task.data_load;
else if(tr_task.ce)begin
    if(tr_task.up_down)
        tr_task.count_out=tr_task.count_out+1;
    else if(!tr_task.up_down)
        tr_task.count_out=tr_task.count_out-1;

end

tr_task.max_count = (tr_task.count_out == {WIDTH{1'b1}})? 1:0;
tr_task.zero = (tr_task.count_out == 0)? 1:0;


endtask

endmodule
