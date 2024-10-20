package sequence_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    import seq_item_pkg::*;

    class reset_sequence extends uvm_sequence #(seq_item);
        `uvm_object_utils(reset_sequence);

        function new(string name ="reset_sequence");
            super.new(name);
        endfunction 

        task body();
            seq_item item;
            item=seq_item::type_id::create("sequence reset");
            start_item(item);
            item.rst=1;
            finish_item(item);
        endtask
    endclass //ALSU_if

    class main_sequence extends uvm_sequence #(seq_item);
        `uvm_object_utils(main_sequence);

        function new(string name ="main_sequence",uvm_component parent=null);
            super.new(name);
        endfunction 

        task body();
            
            repeat(1000)begin
                seq_item item;
                item=seq_item::type_id::create("sequence");
                item.constraint_mode(0);
                item.x.constraint_mode(1);
                start_item(item);
                assert(item.randomize());
                finish_item(item);
                
            end
        endtask
    endclass //ALSU_if

        class second_sequence extends uvm_sequence #(seq_item);
        `uvm_object_utils(second_sequence);

        function new(string name ="second_sequence",uvm_component parent=null);
            super.new(name);
        endfunction 

        task body();

            for(int i=0;i<1000;i++)begin
            seq_item item;
            item=seq_item::type_id::create("sequence");
            item.constraint_mode(0);
            item.y.constraint_mode(1);
            //start_item(item);
            item.rst=0;item.bypass_A=0;item.bypass_B=0;item.red_op_A=0;item.red_op_B=0;
            item.rst.rand_mode(0);item.bypass_A.rand_mode(0);item.bypass_B.rand_mode(0);item.red_op_A.rand_mode(0);
            item.red_op_B.rand_mode(0);          
            assert(item.randomize());
            //if('{OR,XOR,ADD,MULT,SHIFT,ROTATE} ==item.arr)$display("@%0t the wanted sequence is %p",$time,tr.arr);
                foreach(item.arr[j])begin
                    start_item(item);
                    item.opcode=item.arr[j];
                    finish_item(item);
                end
            end
            
        endtask
    endclass //ALSU_if

    
endpackage