import uvm_pkg::*;
    `include "uvm_macros.svh"
import test_pkg::*;

module top();
bit clk=0;
always #5 clk=!clk;

ALSU_if if_t(clk);
shift_reg_if sr_t();
shift_reg SR(sr_t);
ALSU DUT (if_t);


assign sr_t.serial_in=DUT.serial_in_reg;
assign sr_t.direction=DUT.direction_reg;
assign sr_t.mode=DUT.opcode_reg[0];
assign sr_t.datain=if_t.out;
assign DUT.out_shift_reg=sr_t.dataout;

bind ALSU Asseritions AS(if_t);

initial begin
    uvm_config_db #(virtual ALSU_if)::set(null,"*","ALSU_K",if_t);
    uvm_config_db #(virtual shift_reg_if)::set(null,"*","SHIFT_K",sr_t);
    run_test("ALSU_test");
end

endmodule