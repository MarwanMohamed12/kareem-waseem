module top();
bit clk=0;

always #5 clk=!clk;

if_pe if_t(clk);
priority_enc dut(if_t);
priority_enc_tb tb(if_t);
asser ASV(if_t);


endmodule

