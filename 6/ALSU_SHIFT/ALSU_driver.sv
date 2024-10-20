package ALSU_driver_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    import ALSU_seq_item_pkg::*;


    class ALSU_driver extends uvm_driver #(seq_item);
        `uvm_component_utils(ALSU_driver);

        virtual ALSU_if vif;
        seq_item item;

        function new(string name ="driver",uvm_component parent=null);
            super.new(name,parent);
        endfunction 

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                item=seq_item::type_id::create("seq item");
                seq_item_port.get_next_item(item);
                vif.rst=item.rst;
                vif.A=item.A;
                vif.B=item.B;
                vif.cin=item.cin;
                vif.red_op_A=item.red_op_A;
                vif.red_op_B=item.red_op_B;
                vif.bypass_A=item.bypass_A;
                vif.bypass_B=item.bypass_B;
                vif.direction=item.direction;
                vif.serial_in=item.serial_in;
                vif.opcode=item.opcode;
                @(negedge vif.clk);
                seq_item_port.item_done();
            end
        endtask

    endclass //ALSU_if

    
endpackage