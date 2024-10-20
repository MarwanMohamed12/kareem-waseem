package pack;
    typedef enum {MAXPOS=7,MAXNEG=-8,ZERO=0} corner_e;
    class transaction;
        bit clk;
        rand bit reset;
        rand bit signed [3:0] A;	// bit data A in 2's complement
        rand bit signed [3:0] B;	// bit data B in 2's complement
        bit signed [4:0] C;
        rand corner_e wanted_case_A,wanted_case_B;
        rand bit signed [3:0] remaning_A,remaning_B;

        constraint x{
            remaning_A!= MAXPOS || MAXNEG ||ZERO;
            remaning_B!= MAXPOS || MAXNEG ||ZERO;
            reset dist {1:=2,0:=98};
            A dist {wanted_case_A:=80,remaning_A:=20};
            B dist {wanted_case_B:=80,remaning_B:=20};
        }

        covergroup Covgrp_A;
            CP_A1: coverpoint A{
                bins data_0={0};
                bins data_max={MAXPOS};
                bins data_min={MAXNEG};
                bins data_default=default;
            }
            CP_A2: coverpoint A{
                bins data_0max=(ZERO=>MAXPOS);
                bins data_maxmin=(MAXPOS=>MAXNEG);
                bins data_minmax=(MAXNEG=>MAXPOS);
            }
        endgroup

        covergroup Covgrp_B;
            CP_B1: coverpoint A{
                bins data_0={0};
                bins data_max={MAXPOS};
                bins data_min={MAXNEG};
                bins data_default=default;
            }
            CP_B2: coverpoint A{
                bins data_0max=(ZERO=>MAXPOS);
                bins data_maxmin=(MAXPOS=>MAXNEG);
                bins data_minmax=(MAXNEG=>MAXPOS);
            }
        endgroup


        function new();
            Covgrp_A =new();
            Covgrp_B =new();
        endfunction //new()
    endclass //transaction
endpackage
