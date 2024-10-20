

package sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import seq_item_pkg::*;
    class shit_reg_sequence extends uvm_sequence #(seq_item);
        `uvm_object_utils(shit_reg_sequence);
        seq_item sq;
        function new(string name = "shift_reg_sequence");
            super.new(name);
        endfunction

        task body();
            repeat(100)begin
                sq=seq_item::type_id::create("sequence")   ; 
                start_item(sq);
                assert(sq.randomize());
                finish_item(sq);

            end

        endtask

    

    endclass
endpackage
