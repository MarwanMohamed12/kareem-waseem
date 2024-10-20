package  shift_sequencer_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
    import shift_seq_item_pkg::*;
    class shift_reg_sequencer extends uvm_sequencer #(shift_seq_item);
        `uvm_component_utils(shift_reg_sequencer);

        function new(string name="sequencer",uvm_component phase);
            super.new(name,phase);
        endfunction
    endclass


endpackage