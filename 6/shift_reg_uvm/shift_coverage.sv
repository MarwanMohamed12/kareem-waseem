package coverage_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import seq_item_pkg::*;

    class shift_reg_cov extends uvm_component;
        `uvm_component_utils(shift_reg_cov);

        seq_item itm;
        uvm_analysis_export #(seq_item) cov_export;
        uvm_tlm_analysis_fifo #(seq_item) cov_fifo;

        //covergorup
        covergroup covgup;
            data_in:coverpoint itm.datain;
            MODE:coverpoint itm.mode;
            direction:coverpoint itm.direction;
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
            cov_fifo.get(itm);
            covgup.sample();
        endtask      
  
    endclass
endpackage