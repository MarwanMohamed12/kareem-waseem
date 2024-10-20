package ALSU_monitor_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    import ALSU_seq_item_pkg::*;    

    class ALSU_mointor extends uvm_monitor ;
        `uvm_component_utils(ALSU_mointor);
        virtual ALSU_if vif;
        seq_item item;
        uvm_analysis_port #(seq_item) mon_p;

        function new(string name ="",uvm_component parent=null);
            super.new(name,parent);
        endfunction 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_p=new("alsu monitor port",this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                item=seq_item::type_id::create("items recived");
                @(negedge vif.clk);
                item.rst=vif.rst;
                item.A=vif.A;
                item.B=vif.B;
                item.cin=vif.cin;
                item.red_op_A=vif.red_op_A;
                item.red_op_B=vif.red_op_B;
                item.bypass_A=vif.bypass_A;
                item.bypass_B=vif.bypass_B;
                item.direction=vif.direction;
                item.serial_in=vif.serial_in;
                item.opcode=vif.opcode;
                mon_p.write(item);
                 `uvm_info("run_phase",item.convert2string(),UVM_HIGH);
            end
        endtask



    endclass //ALSU_if

    
endpackage