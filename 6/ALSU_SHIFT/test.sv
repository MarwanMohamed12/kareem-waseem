package test_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    import ALSU_sequence_pkg::*;
    import ALSU_env_pkg::*;
    import shift_env_pkg::*;
    import config_object_pkg::*;
    import ALSU_seq_item_pkg::*;
    class ALSU_test extends uvm_test;
        `uvm_component_utils(ALSU_test);

        reset_sequence reset_seq;
        main_sequence main_seq;
        second_sequence second;

        ALSU_env A_env;
        shit_reg_env S_env;

        virtual ALSU_if vif;
        ALSU_config ALSU_cfg;
        ALSU_config SHIFT_cfg;

        function new(string name ="test",uvm_component parent=null);
            super.new(name,parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            reset_seq=reset_sequence::type_id::create("reset");
            main_seq =main_sequence::type_id::create("main");
            second=second_sequence::type_id::create("second");

            A_env=ALSU_env::type_id::create("ALSU env",this); 
            S_env=shit_reg_env::type_id::create("SHIFT env",this); 

            set_type_override_by_type(seq_item::get_type(), alsu_seq_item_valid_invalid::get_type());
            ALSU_cfg=ALSU_config::type_id::create("ALSU object");
            SHIFT_cfg=ALSU_config::type_id::create("SHIFT object");

            if(!uvm_config_db #(virtual ALSU_if)::get(this,"","ALSU_K",ALSU_cfg.vif))
                `uvm_fatal("build_phase","unable to get ALSU virtual if");

            if(!uvm_config_db #(virtual shift_reg_if)::get(this,"","SHIFT_K",SHIFT_cfg.sif))
                `uvm_fatal("build_phase","unable to get shift virtual if");
            ALSU_cfg.is_active =UVM_ACTIVE;
            SHIFT_cfg.is_active =UVM_PASSIVE;

            uvm_config_db #(ALSU_config)::set(this,"*","ALSU_cfg",ALSU_cfg);
            uvm_config_db #(ALSU_config)::set(this,"*","shift_cfg",SHIFT_cfg);

        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            //start seq
           /* `uvm_info("run_phase","reset sequence start",UVM_MEDIUM);
            reset_seq.start(A_env.agt.sqr);*/
            `uvm_info("run_phase","main sequence start",UVM_MEDIUM);
            main_seq.start(A_env.agt.sqr); 
            `uvm_info("run_phase","second sequence start",UVM_MEDIUM);
            second.start(A_env.agt.sqr);     
            phase.drop_objection(this);
        endtask      

            endclass //ALSU_if

    
endpackage