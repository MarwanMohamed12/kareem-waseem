package shift_driver_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_seq_item_pkg::*;

    class shift_reg_driver extends uvm_driver #(shift_seq_item);
        `uvm_component_utils(shift_reg_driver);
        virtual shift_reg_if vif;
        shift_seq_item itm;

        function new(string name = "shift_reg_driver", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                itm=shift_seq_item::type_id::create("item_send");
                seq_item_port.get_next_item(itm);
                vif.serial_in=itm.serial_in;
                vif.direction=itm.direction;
                vif.mode=itm.mode;
                vif.datain=itm.datain;
                #2;

                seq_item_port.item_done();
                `uvm_info("run_phase",itm.convert2string(),UVM_HIGH);

            end
        endtask
    endclass
endpackage