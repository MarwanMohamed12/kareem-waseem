package agent_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    import monitor_pkg::*;
    import sequencer_pkg::*;
    import driver_pkg::*;
    import seq_item_pkg::*;
    import config_object_pkg::*;

    class  ALSU_agent extends uvm_agent;
        `uvm_component_utils(ALSU_agent);
        ALSU_mointor mon;
        ALSU_sequencer sqr;
        ALSU_driver driver;
        ALSU_config cfg;
        uvm_analysis_port #(seq_item) agt_p;

        function new(string name ="agent",uvm_component parent=null);
            super.new(name,parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon=ALSU_mointor::type_id::create("monitor",this);
            sqr=ALSU_sequencer::type_id::create("sequencer",this);
            driver=ALSU_driver::type_id::create("driver",this);
            agt_p=new("agent port",this);
            if(!uvm_config_db #(ALSU_config)::get(this,"","cfg",cfg))
                `uvm_fatal("build_phase","cant get virtual interface");
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            driver.vif=cfg.vif;
            mon.vif=cfg.vif;
            mon.mon_p.connect(agt_p);
            driver.seq_item_port.connect(sqr.seq_item_export);
        endfunction


    endclass //ALSU_if

    
endpackage