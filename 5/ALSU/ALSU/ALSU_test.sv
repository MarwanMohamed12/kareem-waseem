package ALSU_test_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ALSU_env_pkg::*;

    class ALSU_test extends uvm_test;
        `uvm_component_utils(ALSU_test);

        virtual ALSU_if ALSU_test_vif;
        ALSU_env env;

        function new(string name ="ALSU_test",uvm_component parent =null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env=ALSU_env::type_id::create("env",this);
            if(!uvm_config_db #(virtual ALSU_if)::get("this","","V_IF",ALSU_test_vif))
                `uvm_fatal("buid_phase","unable to get virtual if");
            
            uvm_config_db #(virtual ALSU_if)::set("this","*","VI_IF",ALSU_test_vif);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
                #100;`uvm_info("run_phase","Inside the ALSU test",UVM_MEDIUM);
            phase.drop_objection(this);
        endtask
    endclass 
endpackage