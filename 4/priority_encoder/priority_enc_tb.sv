module priority_enc_tb(if_pe.TB if_t);


initial begin
	
if_t.D=1;
if_t.rst=1;
@(negedge if_t.clk);#2;
if_t.rst=0;

for(int i=0;i<16;i++)begin
	if_t.D=i;
	@(negedge if_t.clk);
end
if_t.D=0;
if_t.rst=1;

repeat(2) @(negedge if_t.clk);
$stop;
end


endmodule
