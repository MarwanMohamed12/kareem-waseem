import pack_file::*;
module ALU_tb (if_d.TB if_t);

transaction tr=new();
initial begin
    if_t.reset=1;
    @(negedge if_t.clk);
    if_t.A=0;if_t.B=0;if_t.Opcode=0;
    if_t.reset=0;
    repeat(50) begin
        assert(tr.randomize());   
        if_t.reset=tr.reset;
        if_t.Opcode=tr.Opcode;
        if_t.A=tr.A;
        if_t.B=tr.B; 
	@(negedge if_t.clk);

   
    end
$stop;
end



endmodule
