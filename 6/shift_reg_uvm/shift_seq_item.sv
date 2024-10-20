


package seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class seq_item extends uvm_sequence_item ;
        `uvm_object_utils(seq_item);

        function new(string name = "shift_reg_sequence_item");
            super.new(name);
        endfunction

        rand logic reset;
        rand logic serial_in, direction, mode;
        rand logic [5:0] datain ;
        logic [5:0] dataout;

         function string convert2string();
            return $sformatf("%s  reset =%0b serial_in=%0b ,direction=%0b ,mode=%0b ,datain=%0b ,dataout=%0b ",
            super.convert2string(),reset,serial_in,direction,mode,datain,dataout);            
        endfunction

        function string convert2string_stimulus();
            return $sformatf("%s  reset =%0b serial_in=%0b ,direction=%0b ,mode=%0b ,datain=%0b  ", super.convert2string(),reset,serial_in,direction,mode,datain);            
        endfunction

        constraint x{
            reset dist {1:=95 ,0 :=5};
        }
    

    endclass
endpackage
