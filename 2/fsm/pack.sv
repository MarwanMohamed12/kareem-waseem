package pack;
    typedef enum { Idle=0,zero,one,Store} state_e;
    class fsm_transaction;
        rand bit x,rst;
        bit[9:0]user_count_exp;
        bit y_exp;

        constraint q{
            rst dist {0:=95,1:=5};
            x dist {0:= 67,1:=33};
        }
    endclass //
endpackage
