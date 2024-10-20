

package shift_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_seq_item_pkg::*;
    class shit_reg_sequence extends uvm_sequence #(shift_seq_item);
        `uvm_object_utils(shit_reg_sequence);
        shift_seq_item sq;
        function new(string name = "shift_reg_sequence");
            super.new(name);
        endfunction

        task body();
            repeat(100)begin
                sq=shift_seq_item::type_id::create("shift_seq_item")   ; 
                start_item(sq);
                assert(sq.randomize());
                finish_item(sq);

            end

        endtask

    

    endclass
endpackage
