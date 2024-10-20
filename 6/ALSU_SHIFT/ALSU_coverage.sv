package ALSU_coverage_pkg;
    import uvm_pkg::*;
        `include "uvm_macros.svh"
    import ALSU_seq_item_pkg::*;
            import constant_enums::*;

    class ALSU_coverage extends uvm_component;
        `uvm_component_utils(ALSU_coverage);
        
        seq_item item;
        uvm_analysis_export #(seq_item)cov_ep;
        uvm_tlm_analysis_fifo #(seq_item) cov_fifo;

        covergroup cvr_gp;

        CIN:coverpoint item.cin{
            bins CIN0={0};
            bins CIN1={1};
            option.weight=0;
        }

        red_op_A:coverpoint item.red_op_A{
            bins red_op_A0={0};
            bins red_op_A1={1};
            option.weight=0;
        }
        red_op_B:coverpoint item.red_op_B{
            bins red_op_B0={0};
            bins red_op_B1={1};
            option.weight=0;
        }
        bypass_A:coverpoint item.bypass_A{
            bins bypass_A0={0};
            bins bypass_A1={1};
            option.weight=0;
        }
        bypass_B:coverpoint item.bypass_B{
            bins bypass_B0={0};
            bins bypass_B1={1};
            option.weight=0;
        }
        direction:coverpoint item.direction{
            bins direction0={0};
            bins direction1={1};
            option.weight=0;
        }
        serial_in:coverpoint item.serial_in{
            bins serial_in0={0};
            bins serial_in1={1};
            option.weight=0;
        }


        special:coverpoint item.opcode{
            option.weight=0;
            bins operataions[]={[OR:ROTATE]};
        }
        CB1:coverpoint item.A{
            bins A_data_0={0};
            bins A_data_max={MAXPOS};
            bins A_data_min={MAXNEG};
            bins A_data_walkingones[] ={3'b001,3'b010,3'b100} iff (item.red_op_A);
            bins A_data_default=default;
        }
        CB2:coverpoint item.B{
            bins B_data_0={0};
            bins B_data_max={MAXPOS};
            bins B_data_min={MAXNEG};
            bins B_data_walkingones[] ={3'b001,3'b010,3'b100} iff (item.red_op_B);
            bins B_data_default=default;
        }
        A_M:coverpoint item.opcode{
            bins Bins_arith[] ={ADD,MULT};
        }
        CB3:coverpoint item.opcode{
            bins Bins_shift[]={SHIFT,ROTATE};
            bins Bins_arith[] ={ADD,MULT};
            bins Bins_bitwise[] ={OR,XOR};
            illegal_bins Bins_invalid ={INVALID6,INVALID7};
            bins Bins_trans=(OR=>XOR=>ADD=>MULT=>SHIFT=>ROTATE);
        }
        //1
        corner_case:cross A_M,CB2,CB1{
            ignore_bins walkingA=binsof(CB1.A_data_walkingones) ;
            ignore_bins walkingB=binsof(CB2.B_data_walkingones) ;
        }
        //2
        Addation:cross CIN,special{
            option.cross_auto_bin_max=0;
            bins Add_cin0=binsof(special) intersect {ADD} && binsof(CIN.CIN0) ;
            bins Add_cin1=binsof(special) intersect {ADD} && binsof(CIN.CIN1) ;
        }
        //3
        shift:cross special,serial_in{
            option.cross_auto_bin_max=0;
            bins shift_Si0=binsof(special) intersect {SHIFT} && binsof(serial_in.serial_in0) ;
            bins shift_Si1=binsof(special) intersect {SHIFT} && binsof(serial_in.serial_in0) ;
        }
        //4
        shift_rotate:cross CB3,direction{
            option.cross_auto_bin_max=0;
            bins shu_rot_d0=binsof(CB3.Bins_shift) && binsof(direction.direction0) ;
            bins shu_rot_d1=binsof(CB3.Bins_shift) && binsof(direction.direction1) ;
        }
        //5
        walkingones:cross CB3,CB2,CB1{
            option.cross_auto_bin_max=0;
            bins arithA=binsof(CB3.Bins_bitwise) && binsof(CB2.B_data_0) &&binsof(CB1.A_data_walkingones) ;
            bins arithB=binsof(CB3.Bins_bitwise) && binsof(CB1.A_data_0) &&binsof(CB2.B_data_walkingones) ;
        }
        invalidation:cross red_op_A,red_op_B,special{
	    option.cross_auto_bin_max=0;
            bins ROpA_notXoR=binsof(special) intersect{[ADD:ROTATE]} && binsof(red_op_A.red_op_A1)  ;
            bins ROpB_notXoR=binsof(special) intersect{[ADD:ROTATE]} && binsof(red_op_B.red_op_B1)  ;
        }
    endgroup

        function new(string name ="coverage",uvm_component parent=null);
            super.new(name,parent);
            cvr_gp=new();
        endfunction 


        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_fifo=new("fifo",this);
            cov_ep=new("cov_export",this);
        endfunction

        function void connect_phase(uvm_phase phase);  
            super.connect_phase(phase);
            cov_ep.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);  
            super.run_phase(phase);
            forever begin
                cov_fifo.get(item);
                cvr_gp.sample();
            end

        endtask


    endclass //ALSU_if

    
endpackage