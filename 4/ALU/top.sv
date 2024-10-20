module top();
bit clk=0;

always #50 clk=!clk;

if_d if_t(clk);
ALU_4_bit dut(if_t);
ALU_tb tb(if_t);
Asser ASV(if_t);


endmodule
