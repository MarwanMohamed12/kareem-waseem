package config_object_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
        

    class ALSU_config extends uvm_object ;
        `uvm_object_utils(ALSU_config);
        virtual shift_reg_if sif;
        virtual ALSU_if vif;
        uvm_active_passive_enum is_active;
        
        function new(string name ="configurtion object");
            super.new(name);
        endfunction 


    endclass //ALSU_if

    
endpackage