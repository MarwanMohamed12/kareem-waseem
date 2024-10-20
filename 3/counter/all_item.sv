package all_item;
    parameter WIDTH=4;
    class transaction;
    
    rand bit rst_n,load_n,up_down,ce;
    rand bit [WIDTH-1:0] data_load;
    bit clk;
    logic [WIDTH-1:0] count_out;
    bit zero,max_count;

    constraint x {
        rst_n dist {0:=5,1:=95};
        load_n dist {0:=70,1:=30};
        ce dist {1:=70,0:=30};
    }

    covergroup covgup @(posedge clk);
        coverpoint data_load iff(!load_n);
        CO1:coverpoint count_out iff(rst_n && ce && up_down){
            bins all_values_up[]={[0:15]};
            bins trans_zero=(15=>0);
        }
        CO2:coverpoint count_out iff(rst_n && ce && !up_down){
            bins all_values_down[]={[0:15]};
            bins trans_max=(0=>15);
        }
    endgroup

    function new();
        covgup=new();
    endfunction

    function printing;
        $display("count_out=%0d  , max_count=%0d, zero=%0d",count_out,max_count,zero);
    endfunction
        
endclass 
endpackage
