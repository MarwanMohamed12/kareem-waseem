import pack::*;
module my_mem_tb();

bit clk=0;
logic write;
logic read;
logic [DATA_IN_BITS-1:0] data_in;
logic [ADDRESS_BITS-1:0] address;
logic [DATA_OUT_BITS-1:0] data_out;

int error=0,correct=0;

localparam No_of_inputs=100 ;

my_mem tb(.*);
always #5 clk=!clk;

transaction tr=new();

initial begin
    tr.write=1;
    tr.read=0;
    write=tr.write;
    read=tr.read;

    stimulus_gen(tr,No_of_inputs);

    for(int i=0; i<No_of_inputs;i++)begin
        data_in=tr.data_to_write_array[i];
        address=tr.address_array[i];
        @(negedge clk);
    end
    tr.write=0;
    tr.read=1;
    write=tr.write;
    read=tr.read;

    for(int i=No_of_inputs-1; i>=0;i--)begin
        address=tr.address_array[i];
        tr.data_out=data_out;
        self_check(tr);
        tr.data_read_queue.push_back(data_out);

    end
    while(tr.data_read_queue.size())
        $display("data =%0d",tr.data_read_queue.pop_front);

    // for code coverage
    tr.write=1;
    tr.read=0;
    write=tr.write;
    read=tr.read;

    stimulus_gen(tr,15);
    
    for(int i=0; i<15;i++)begin
        data_in=tr.data_to_write_array[i];
        address=tr.address_array[i];
        @(negedge clk);
    end
    tr.write=0;
    tr.read=1;
    write=tr.write;
    read=tr.read;

    for(int i=14; i>=0;i--)begin
        address=tr.address_array[i];
        tr.data_out=data_out;
        self_check(tr);
        tr.data_read_queue.push_back(data_out);

    end
	tr.write=0;
    tr.read=0;
    write=tr.write;
    read=tr.read;
	self_check(tr);
	
    $display("error=%0d,correct=%0d",error,correct);

$stop;

end

task stimulus_gen(transaction trans,input int no_of_inputs);
    for(int i=0;i<no_of_inputs;i++)begin
        assert(trans.randomize());
        trans.address_array[i]=trans.address;
        trans.data_to_write_array[i]=trans.data_in;
    end
    golden_model(trans);
endtask

task golden_model(transaction fill);
    if(tr.write)begin
        foreach(fill.address_array[i])begin//{~^data_in, data_in}
            fill.data_read_expect_assoc[fill.address_array[i]]={^fill.data_to_write_array[i],fill.data_to_write_array[i]};
        end
    end
endtask

task self_check(transaction tr);
    @(negedge clk);
    if(tr.data_read_expect_assoc[address] != data_out)begin
        $display("@%0t there is error, address=%0d ,data_out=%0d ,right data_out=%0d",$time ,address,tr.data_out,tr.data_read_expect_assoc[address]);
        error++;
    end
    else
    correct++;
endtask

endmodule
