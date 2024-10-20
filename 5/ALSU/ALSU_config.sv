package ALSU_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_config_obj extends uvm_object;
    `uvm_object_utils(alsu_config_obj);

    virtual ALSU_if alsu_config_vif;
    function new(string name="ALSU_config");
        super.new(name);
    endfunction

endclass

endpackage
