package config_object_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
        

    class ALSU_config extends uvm_object ;
        `uvm_object_utils(ALSU_config);

        virtual ALSU_if vif;
        function new(string name ="configurtion object");
            super.new(name);
        endfunction 


    endclass //ALSU_if

    
endpackage