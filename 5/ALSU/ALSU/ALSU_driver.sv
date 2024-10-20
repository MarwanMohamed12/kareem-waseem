package ALSU_driver_pkg;

import uvm_pkg::*;
    `include  "uvm_macros.svh"

class ALSU_driver extends uvm_driver;
    `uvm_component_utils(ALSU_driver);

    virtual ALSU_if ALSU_vif;

    function new(string name="ALSU_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual ALSU_if)::get("this","","VI_IF",ALSU_vif))
                `uvm_fatal("build_phase","unable to get virtual if");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        ALSU_vif.rst=0;
        @(negedge ALSU_vif.clk);
        forever begin
            ALSU_vif.cin=$random; ALSU_vif.cin=$random;ALSU_vif.red_op_A=$random;
            ALSU_vif.red_op_B=$random;ALSU_vif.bypass_A=$random;
            ALSU_vif.bypass_B=$random; ALSU_vif. direction=$random;
            ALSU_vif.serial_in=$random; 
            ALSU_vif.A=$random;ALSU_vif.B=$random;
            @(negedge ALSU_vif.clk);
        end

    endtask




endclass











endpackage