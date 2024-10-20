import uvm_pkg::*;
    `include "uvm_macros.svh"
import ALSU_test_pkg::*;

module top();
bit clk=0;
always #5 clk=!clk;

ALSU_if if_t(clk);
ALSU DUT (.clk(if_t.clk), .rst(if_t.rst), .cin(if_t.cin), .red_op_A(if_t.red_op_A), .red_op_B(if_t.red_op_B), 
            .bypass_A(if_t.bypass_A),.bypass_B(if_t.bypass_B),.direction(if_t.direction), 
            .serial_in(if_t.serial_in),.opcode(if_t.opcode),.A(if_t.A),.B(if_t.B),.leds(if_t.leds),.out(if_t.out));

initial begin
    uvm_config_db #(virtual ALSU_if)::set(null,"uvm_test_top","V_IF",if_t);
    run_test("ALSU_test");
end

endmodule