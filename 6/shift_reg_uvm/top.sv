import uvm_pkg::*;
`include "uvm_macros.svh"
import test_pkg::*;
module top();

bit clk=0;

always #100 clk=!clk;


shift_reg_if if_t(clk);
shift_reg dut(if_t);


initial begin
uvm_config_db #(virtual shift_reg_if)::set(null,"*","virtualIf",if_t);
run_test("shift_reg_test");
end



endmodule