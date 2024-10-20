package config_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
    class shift_reg_config extends uvm_object ;
        `uvm_object_utils(shift_reg_config);
        virtual shift_reg_if vif;
        function new(string name="config_object");
            super.new(name);
        endfunction
    endclass
endpackage