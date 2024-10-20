package scoreboard_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import seq_item_pkg::*;

    class shift_reg_sb extends uvm_scoreboard;
        `uvm_component_utils(shift_reg_sb);

        seq_item itm;
        logic [5:0] dataout_ref;
        int error,correct;
        uvm_analysis_export #(seq_item) sb_export;
        uvm_tlm_analysis_fifo #(seq_item) sb_fifo;
        function new(string name = "shift_reg_sb", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export=new("sb_export",this);
            sb_fifo=new("sb_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);  
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(itm);
                refrence_model(itm);
                if(itm.dataout != dataout_ref)begin
                    `uvm_error("run_phase",$sformatf("Trascaion recieved is %s and data_out ref =%0d",itm.convert2string(),dataout_ref));
                    error++;
                end
                else correct++;
            end
        endtask

        task refrence_model(seq_item itms);
            if (itms.reset)
                dataout_ref = 0;
            else
                if (itms.mode) // rotate
                    if (itms.direction) // left
                        dataout_ref = {itms.datain[4:0], itms.datain[5]};
                    else
                        dataout_ref = {itms.datain[0], itms.datain[5:1]};
                else // shift
                    if (itms.direction) // left
                        dataout_ref = {itms.datain[4:0], itms.serial_in};
                    else
                        dataout_ref = {itms.serial_in, itms.datain[5:1]};

        endtask

        function void report_phase (uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("cases passed %0d,failed cases %0d",correct,error),UVM_MEDIUM);
        endfunction 


    endclass





endpackage