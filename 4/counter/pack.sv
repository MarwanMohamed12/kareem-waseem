package pack;
    parameter WIDTH=4;
    class transaction;
    
    rand bit rst_n,load_n,up_down,ce;
    rand bit [WIDTH-1:0] data_load;
    bit [WIDTH-1:0] count_out;
    bit zero,max_count,clk;
    constraint x {
        rst_n dist {0:=5,1:=100};
        load_n dist {0:=70,1:=30};
        ce dist {1:=70,0:=30};
    }
    covergroup covgup @(posedge clk) ;
        coverpoint data_load iff(!load_n);
        COUNT_UP:coverpoint count_out iff(rst_n && ce && up_down){
            bins all_values_up[]={[0:15]};
            bins trans_zero=(15=>0);
        }
        COUNT_DOWN:coverpoint count_out iff(rst_n && ce && !up_down){
            bins all_values_down[]={[0:15]};
            bins trans_max=(0=>15);
        }
        max_check :cross count_out,max_count{
            option.cross_auto_bin_max=0;
            bins max_detect=binsof(count_out) intersect{15} && binsof(max_count) intersect {1};
            illegal_bins invalid=binsof(count_out) intersect{[0:14]} && binsof(max_count) intersect {1};
        }
        zeros_check :cross count_out,zero{
            option.cross_auto_bin_max=0;
            bins zero_detect=binsof(count_out) intersect{0} && binsof(zero) intersect {1};
            illegal_bins invalid=binsof(count_out) intersect{[1:15]} && binsof(zero) intersect {1};
        }
    endgroup 




    function new();
       covgup=new();
    endfunction
        
endclass 
endpackage
