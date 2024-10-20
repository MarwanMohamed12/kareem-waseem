package pack_alsu;
typedef enum { OR=0,XOR,ADD,MULT,SHIFT,ROTATE,INVALID6,INVALID7 } Opcode_e;
typedef enum {MAXPOS=3,MAXNEG=-4,ZERO=0}corner_state_e;

class transaction;
    rand bit  clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    rand Opcode_e opcode;
    rand bit signed [2:0] A, B;
    bit [2:0] ones_number={3'b001,3'b010,3'b100};
    rand bit [2:0] found,notfound;
    rand corner_state_e a_state;
    rand bit [2:0] rem_numbers;
    bit signed [5:0] out;
    bit [15:0] leds;

    rand Opcode_e arr[6];

    constraint x {

       rem_numbers!= MAXPOS||MAXNEG||ZERO;

        rst dist {1:=5 , 0:=95};

        found inside {ones_number};
        !(notfound inside {ones_number});

        if (opcode ==ADD || opcode== MULT){
            A dist {a_state:=80,rem_numbers:=20};
            B dist {a_state:=80,rem_numbers:=20};
        }
        if (opcode ==OR || opcode== XOR ){
            if(red_op_A){
                A dist {found:=80,notfound:=20};
                B==3'b000;  
            }
            else if (red_op_B){
                B dist {found:=80,notfound:=20};
                A==3'b000;
            }
        }


        opcode dist {[OR:ROTATE]:=80,[INVALID6:INVALID7]};

        bypass_A dist {0:=90,1:=10};
        bypass_B dist {0:=90,1:=10};
    }
    constraint y{
        unique{arr};
        foreach(arr[i])
            arr[i] inside {[OR:ROTATE]};
    }


    covergroup cvr_gp;
        special:coverpoint opcode{
            option.weight=0;
            bins operataions[]={[OR:ROTATE]};
        }
        CB1:coverpoint A{
            bins A_data_0={0};
            bins A_data_max={MAXPOS};
            bins A_data_min={MAXNEG};
            bins A_data_walkingones[] ={3'b001,3'b010,3'b100} iff (red_op_A);
            bins A_data_default=default;
        }
        CB2:coverpoint B{
            bins B_data_0={0};
            bins B_data_max={MAXPOS};
            bins B_data_min={MAXNEG};
            bins B_data_walkingones[] ={3'b001,3'b010,3'b100} iff (red_op_B);
            bins B_data_default=default;
        }
        A_M:coverpoint opcode{
            bins Bins_arith[] ={ADD,MULT};
        }
        CB3:coverpoint opcode{
            bins Bins_shift[]={SHIFT,ROTATE};
            bins Bins_arith[] ={ADD,MULT};
            bins Bins_bitwise[] ={OR,XOR};
            illegal_bins Bins_invalid ={INVALID6,INVALID7};
            bins Bins_trans=(OR=>XOR=>ADD=>MULT=>SHIFT=>ROTATE);
        }
        //1
        corner_case:cross A_M,CB2,CB1{
            ignore_bins walkingA=binsof(CB1.A_data_walkingones) ;
            ignore_bins walkingB=binsof(CB2.B_data_walkingones) ;
        }
        //2
        Addation:cross cin,special{
            option.cross_auto_bin_max=0;
            bins Add_cin0=binsof(special) intersect {ADD} && binsof(cin) intersect {0};
            bins Add_cin1=binsof(special) intersect {ADD}&& binsof(cin) intersect {1};
        }
        //3
        shift:cross special,serial_in{
            option.cross_auto_bin_max=0;
            bins shift_Si0=binsof(special) intersect {SHIFT} && binsof(serial_in) intersect {0};
            bins shift_Si1=binsof(special) intersect {SHIFT} && binsof(serial_in) intersect {1};
        }
        //4
        shift_rotate:cross CB3,direction{
            option.cross_auto_bin_max=0;
            bins shu_rot_d0=binsof(CB3.Bins_shift) && binsof(direction) intersect {0} ;
            bins shu_rot_d1=binsof(CB3.Bins_shift) && binsof(direction) intersect {1} ;
        }
        //5
        walkingones:cross CB3,CB2,CB1{
            option.cross_auto_bin_max=0;
            bins arithA=binsof(CB3.Bins_bitwise) && binsof(CB2.B_data_0) &&binsof(CB1.A_data_walkingones) ;
            bins arithB=binsof(CB3.Bins_bitwise) && binsof(CB1.A_data_0) &&binsof(CB2.B_data_walkingones) ;
        }
        invalidation:cross red_op_A,red_op_B,special{
	    option.cross_auto_bin_max=0;
            bins ROpA_notXoR=binsof(special) intersect{[ADD:ROTATE]} && binsof(red_op_A)  intersect{1};
            bins ROpB_notXoR=binsof(special) intersect{[ADD:ROTATE]} && binsof(red_op_B)  intersect{1};
        }

    endgroup

    function new();
        cvr_gp=new();
    endfunction

endclass 
endpackage
