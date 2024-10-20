package pack;
    typedef enum { Idle=0,zero,one,Store} state_e;
    class fsm_transaction;
        rand bit x,rst;
        bit[9:0]user_count_exp;
        bit y_exp;
        bit clk;
        state_e check;
        constraint q{
            rst dist {0:=95,1:=5};
            x dist {0:= 67,1:=33};
        }

        covergroup Covgup @(negedge clk);
            cover_x:coverpoint x{
                bins wanted_seq=(0=>1=>0);
            }
            stats:coverpoint check{
                bins t1=(Idle=>Idle);
                bins t2=(Idle=>zero);
                bins t3=(zero=>zero);
                bins t4=(zero=>one);
                bins t5=(one=>Store);
                bins t6=(one=>Idle);
                bins t7=(Store=>Idle);
                bins t8=(Store=>zero);
                bins reseting=(Idle,zero,one,Store=>Idle); // case reset
                illegal_bins wrong_transation=(0=>2,3,1=>0,3,2=>1,2,3=>2,3);
            }

        endgroup

        function new();
            Covgup=new();
        endfunction
    endclass //
endpackage
