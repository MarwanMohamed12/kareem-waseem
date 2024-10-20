import uvm_pkg::*;
    `include "uvm_macros.svh"
import test_pkg::*;

module top();
bit clk=0;
always #5 clk=!clk;

ALSU_if if_t(clk);
ALSU DUT (if_t);

bind ALSU Asseritions AS(if_t);

initial begin
    uvm_config_db #(virtual ALSU_if)::set(null,"*","VIF",if_t);
    run_test("ALSU_test");
end

endmodule