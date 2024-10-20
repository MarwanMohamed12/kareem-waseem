

package test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

import sequence_pkg::*;
import env_pkg::*;
import config_pkg::*;

    class shift_reg_test extends uvm_test;
        `uvm_component_utils(shift_reg_test);
        shit_reg_sequence sq;
        shit_reg_env     env;
        shift_reg_config cfg;

        function new(string name = "shift_reg_test", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);        
            super.build_phase(phase);
            sq=shit_reg_sequence::type_id::create("sequence");
            env=shit_reg_env::type_id::create("env",this);
            cfg=shift_reg_config::type_id::create("config");

            if(! uvm_config_db #(virtual shift_reg_if)::get(this,"","virtualIf",cfg.vif))
                `uvm_fatal("build_phase","cant get virtual interface");

            uvm_config_db #(shift_reg_config)::set(this,"*","done",cfg);
        endfunction

        task run_phase(uvm_phase phase);        
            super.build_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase","sequence has started now",UVM_MEDIUM);
            sq.start(env.agent.sqr);
            phase.drop_objection(this);

        endtask
        

    endclass

endpackage