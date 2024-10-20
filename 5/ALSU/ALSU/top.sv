
import uvm_pkg::*;
    `include "uvm_macros.svh"
import ALSU_test_pkg::*;

module top();

bit clk=0;

always #100 clk=!clk;


ALSU_if if_t(clk);
ALSU DUT (clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in,opcode,A,B,leds,out);

initial begin
    uvm_config_db #(virtual ALSU_if)::set(null,"uvm_test_top","V_IF",if_t);
    run_test("ALSU_test");
end



endmodule