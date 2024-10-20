
package all_item;
    parameter WIDTH=4;
    class transaction;
    
    rand bit rst_n,load_n,up_down,ce;
    rand bit [WIDTH-1:0] data_load;
    
    constraint x {
        rst_n dist {0:=5,1:=95};
        load_n dist {0:=70,1:=30};
        ce dist {1:=70,0:=30};
    }

    /*function printing;
        $display("count_out=%0d  , max_count=%0d, zero=%0d",count_out,max_count,zero);
    endfunction*/
        
endclass 
endpackage

int error=0,correct =0;
import all_item::*;
module counter_tb();

logic clk=1,rst_n,load_n,up_down,ce;
logic  [WIDTH-1:0] data_load;
logic  [WIDTH-1:0] count_out;
logic max_count,zero;
bit[3:0] last_value=0;
counter co(.*);

always #5 clk=!clk;

transaction tr=new();

initial begin
    rst_n=0;
    test();
    repeat(100)begin
        assert (tr.randomize());
	    rst_n=tr.rst_n;
        load_n=tr.load_n;
        up_down=tr.up_down;
        ce=tr.ce;
        data_load=tr.data_load ;
        test();
      // tr.printing();
    end
    $display("number of correct =%0d ,error=%0d",correct,error);
$finish;
end

task test();
    
    @(negedge clk);
    if (rst_n==0) begin
        if(count_out!=0 || zero!=1 || max_count!=0)begin
            $display("@%0t there is problem in reset",$time);error++;
        end
        else correct++;
    end
    else begin
        if (load_n==0)begin //check on load case 
            if(data_load==0  && (count_out!=0 || max_count!=0 || zero!=1))begin
                $display("@%0t there is problem in zero case ",$time); error++;
            end
            else if (data_load==15 && (count_out!=15 || max_count!=1 || zero!=0) )begin
                    $display("@%0t there is problem in max case ",$time);error++;
            end
            else if (count_out!=data_load )begin
                    $display("@%0t there is problem in loading ",$time);error++;
            end
            else  correct++;
        end 
        else begin
            if (ce)begin
                if ((up_down==1 && count_out!=last_value+4'b0001) || 
                    (up_down==1 && last_value==14 && max_count!=1) || (up_down==1 && last_value==15 && zero!=1) )begin
                        $display("@%0t there is problem in count up ",$time);error++;
                end
                else if ((up_down==0 && count_out!=last_value-4'b0001) ||
                         (up_down==0 && last_value==0 && max_count!=1) || (up_down==0 && last_value==1 && zero!=1) )begin
                        $display("@%0t there is problem in count down and value =%0d",$time,(last_value-4'b0001));error++;
                end 
                else correct++;
            end
            else 
                if(!ce )begin
                    if(count_out!=last_value)begin
                        $display("@%0t there is problem in enaple ",$time);error++;
                    end
                    else
                    begin 
                        correct++;
                    end
                end
        end
    end
    
    last_value=count_out;

	#1;
endtask



endmodule
