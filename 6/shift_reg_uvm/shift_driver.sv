package driver_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import seq_item_pkg::*;

    class shift_reg_driver extends uvm_driver #(seq_item);
        `uvm_component_utils(shift_reg_driver);
        virtual shift_reg_if vif;
        seq_item itm;

        function new(string name = "shift_reg_driver", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                itm=seq_item::type_id::create("item_send");
                seq_item_port.get_next_item(itm);
                vif.reset=itm.reset;
                vif.serial_in=itm.serial_in;
                vif.direction=itm.direction;
                vif.mode=itm.mode;
                vif.datain=itm.datain;
                @(negedge vif.clk);

                seq_item_port.item_done();
                `uvm_info("run_phase",itm.convert2string(),UVM_HIGH);

            end
        endtask
    endclass
endpackage