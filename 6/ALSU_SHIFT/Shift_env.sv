

package shift_env_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
    import shift_scoreboard_pkg::*;
    import shift_coverage_pkg::*;
    import shift_agent_pkg::*;

    class shit_reg_env extends uvm_component ;
        `uvm_component_utils(shit_reg_env);
        shift_reg_sb sb;
        shift_reg_cov cov;
        shift_reg_agent agent;

        function new(string name = "shift_reg_env", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);        
            super.build_phase(phase);
            sb=shift_reg_sb::type_id::create("scoreboard",this);
            cov=shift_reg_cov::type_id::create("coverage collector",this);
            agent=shift_reg_agent::type_id::create("Agent",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.agt_p.connect(sb.sb_export);
            agent.agt_p.connect(cov.cov_export);
        endfunction
    endclass
endpackage
