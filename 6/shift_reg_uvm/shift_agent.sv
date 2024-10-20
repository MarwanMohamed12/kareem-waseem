package agent_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import monitor_pkg::*;
import driver_pkg::*;
import sequencer_pkg::*;
import config_pkg::*;
import seq_item_pkg::*;

    class shift_reg_agent extends uvm_agent;
        `uvm_component_utils(shift_reg_agent);
        shift_reg_monitor mon;
        shift_reg_sequencer sqr;
        shift_reg_driver drv;
        uvm_analysis_port #(seq_item) agt_p;
        shift_reg_config cfg;

        function new(string name = "shift_reg_agent", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon=shift_reg_monitor::type_id::create("monitor",this);
            sqr=shift_reg_sequencer::type_id::create("driver",this);
            drv=shift_reg_driver::type_id::create("sequencer",this);
            agt_p=new("agent_port",this);
            if(!uvm_config_db #(shift_reg_config)::get(this,"","done",cfg))
                `uvm_fatal("build_phase","cant get virtual interface");

        endfunction

        function void connect_phase(uvm_phase phase);  
            super.connect_phase(phase);
            mon.mon_p.connect(agt_p);
            drv.seq_item_port.connect(sqr.seq_item_export);
            drv.vif=cfg.vif;
            mon.vif=cfg.vif;
        endfunction
        

    endclass





endpackage