package test_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    import sequence_pkg::*;
    import env_pkg::*;
    import config_object_pkg::*;

    class ALSU_test extends uvm_test;
        `uvm_component_utils(ALSU_test);

        reset_sequence reset_seq;
        main_sequence main_seq;
        second_sequence second;
        ALSU_env env;
        virtual ALSU_if vif;
        ALSU_config cfg;


        function new(string name ="test",uvm_component parent=null);
            super.new(name,parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            reset_seq=reset_sequence::type_id::create("reset");
            main_seq =main_sequence::type_id::create("main");
            second=second_sequence::type_id::create("second");
            env=ALSU_env::type_id::create("env",this); 
            cfg=ALSU_config::type_id::create("object");
            if(!uvm_config_db #(virtual ALSU_if)::get(this,"","VIF",cfg.vif))
                `uvm_fatal("build_phase","unable to get virtual if");

            uvm_config_db #(ALSU_config)::set(this,"*","cfg",cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            //start seq
            `uvm_info("run_phase","reset sequence start",UVM_MEDIUM);
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase","main sequence start",UVM_MEDIUM);
            main_seq.start(env.agt.sqr); 
            `uvm_info("run_phase","second sequence start",UVM_MEDIUM);
            second.start(env.agt.sqr);     
            phase.drop_objection(this);
        endtask      

            endclass //ALSU_if

    
endpackage