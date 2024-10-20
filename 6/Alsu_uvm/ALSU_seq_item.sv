package seq_item_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
        import constant_enums::*;

    class seq_item extends uvm_sequence_item;
        `uvm_object_utils(seq_item);
        rand bit  clk, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        rand logic cin;
        rand logic  [2:0] opcode;
        rand bit signed [2:0] A, B;
        bit signed [5:0] out;
        bit [15:0] leds;

        bit [2:0] ones_number={3'b001,3'b010,3'b100};
        rand bit [2:0] found,notfound;
        rand corner_state_e a_state;
        rand bit [2:0] rem_numbers;
        rand Opcode_e arr[6];
        function new(string name ="seq_item");
            super.new(name);
        endfunction 

        function string convert2string();
            return $sformatf("%s  reset =%0b cin=%0b ,red_op_A=%0b ,red_op_B=%0b ,bypass_A=%0b ,bypass_B=%0b ,
            direction=%0b ,serial_in=%0b ,opcode=%0b ,A=%0b,B=%0b ,out =%0b,leds=%0b ",
            super.convert2string(),rst,cin,red_op_A,red_op_B,bypass_A,bypass_B,direction,serial_in,opcode,A,B,out,leds);            
        endfunction

        function string convert2string_stimulus();
            return $sformatf("%s  reset =%0b cin=%0b ,red_op_A=%0b ,red_op_B=%0b ,bypass_A=%0b ,bypass_B=%0b ,
            direction=%0b ,serial_in=%0b ,opcode=%0b ,A=%0b,B=%0b",
            super.convert2string(),rst,cin,red_op_A,red_op_B,bypass_A,bypass_B,direction,serial_in,opcode,A,B);              
        endfunction

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
    endclass //ALSU_if

    
endpackage