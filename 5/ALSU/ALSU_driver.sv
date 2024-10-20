package ALSU_driver_pkg;

import uvm_pkg::*;
    `include  "uvm_macros.svh"
import ALSU_config_pkg::*;
class ALSU_driver extends uvm_driver;
    `uvm_component_utils(ALSU_driver);

    virtual ALSU_if alsu_driver_vif;
    alsu_config_obj alsu_config_obj_driver;

    function new(string name="ALSU_driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(alsu_config_obj)::get(this,"","VF",alsu_config_obj_driver))
                `uvm_fatal("build_phase","unable to get virtual if");
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        alsu_driver_vif=alsu_config_obj_driver.alsu_config_vif;
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        alsu_driver_vif.rst = 1;
            alsu_driver_vif.A=0;
            alsu_driver_vif.B=0;
            alsu_driver_vif.cin=0;
            alsu_driver_vif.serial_in=0;
            alsu_driver_vif.red_op_A =0;
            alsu_driver_vif.red_op_B =0;
            alsu_driver_vif.opcode   =0 ;
            alsu_driver_vif.bypass_A =0;
            alsu_driver_vif.bypass_B =0;
            alsu_driver_vif.direction=0;
        forever begin
            @(negedge alsu_driver_vif.clk) begin
                alsu_driver_vif.rst = 0 ;
                alsu_driver_vif.A = $urandom;
                alsu_driver_vif.B = $urandom;
                alsu_driver_vif.cin = $urandom;
                alsu_driver_vif.serial_in = $urandom;
                alsu_driver_vif.red_op_A = $urandom;
                alsu_driver_vif.red_op_B = $urandom;
                alsu_driver_vif.opcode = $urandom;
                alsu_driver_vif.bypass_A = $urandom;
                alsu_driver_vif.bypass_B = $urandom;
                alsu_driver_vif.direction = $urandom;
            end
        end
    endtask
endclass

endpackage