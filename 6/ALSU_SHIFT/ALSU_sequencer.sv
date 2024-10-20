package ALSU_sequencer_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    import ALSU_seq_item_pkg::*;

    class ALSU_sequencer extends uvm_sequencer #(seq_item);
        `uvm_component_utils(ALSU_sequencer);

        function new(string name ="sequencer",uvm_component parent=null);
            super.new(name,parent);
        endfunction 


    endclass //ALSU_if

    
endpackage