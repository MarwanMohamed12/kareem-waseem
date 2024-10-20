package ALSU_env_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    import ALSU_coverage_pkg::*;    
    import ALSU_agent_pkg::*;

    class ALSU_env extends uvm_env;
        `uvm_component_utils(ALSU_env);
        ALSU_coverage cov;
        ALSU_agent agt;

        function new(string name ="env",uvm_component parent=null);
            super.new(name,parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov=ALSU_coverage::type_id::create("coverage",this);
            agt=ALSU_agent::type_id::create("agent",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_p.connect(cov.cov_ep);
        endfunction

    endclass //ALSU_if

    
endpackage