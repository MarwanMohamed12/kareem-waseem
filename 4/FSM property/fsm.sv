module fsm();

property fsm1;// if we dont have a clock
@(cs) $onehot(cs);
endproperty



property fsm2;
@(posedge clk) (cs==IDLE && $rose(get_data) ) |=> (cs==GEN_BLK_ADDR) [*64] ##1 (cs==WAITO);
endproperty



endmodule