package shift_coverage_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_seq_item_pkg::*;

    class shift_reg_cov extends uvm_component;
        `uvm_component_utils(shift_reg_cov);

        shift_seq_item itm;
        uvm_analysis_export #(shift_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(shift_seq_item) cov_fifo;

        //covergorup
        covergroup covgup;
            data_in:coverpoint itm.datain  ;
            MODE:coverpoint itm.mode {
                bins mode0={0};
                bins mode1={1};
            }
            direction:coverpoint itm.direction{
                bins direction0={0};
                bins direction1={1};
            }
        endgroup

        function new(string name = "shift_reg_cov", uvm_component parent =null);
            super.new(name,parent);
            covgup=new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export=new("cov_export",this);
            cov_fifo=new("cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);  
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction  

        task run_phase(uvm_phase phase);  
            super.run_phase(phase);
            forever begin
                cov_fifo.get(itm);
                //`uvm_info("run_phase",itm.convert2string(),UVM_MEDIUM);
                covgup.sample();
            end
        endtask      
  
    endclass
endpackage