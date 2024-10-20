package  pack_file;
    typedef enum { Add,Sub,Not_A,ReductionOR_B } Opcode_e;
    typedef enum {MAXPOS=7,MAXNEG=-8,ZERO=0}corner_state_e;
    class transaction;
        rand bit reset;
        rand Opcode_e Opcode;
        rand bit signed [3:0] A;
        rand bit signed [3:0] B;
        rand corner_state_e corner;
        rand bit [3:0] rem;
        

        constraint x {
            rem!=MAXPOS||MAXNEG||ZERO;

            reset dist {0:=95,1:=5};
	        Opcode dist {[Add:Sub]:=50,[Not_A:ReductionOR_B]:=30};
            if(Opcode==Add ||Opcode == Sub){
            A dist {corner :=70,rem:=30};
            }
            if(Opcode==Not_A){
                B==0;
                A dist {0:=40,4'b1111:=40};
            }
            if(Opcode==ReductionOR_B){
                A==0;
                B dist {0:=40,4'b1111:=40};
            }
        }
    endclass 
endpackage
