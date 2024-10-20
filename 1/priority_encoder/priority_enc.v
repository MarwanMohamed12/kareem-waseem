module priority_enc (
input  clk,
input  rst,
input  [3:0] D,	
output  reg[1:0] Y,	
output  reg valid
);

always @(posedge clk) begin
  if (rst) begin
     Y <= 2'b0;
	 valid<=1'b0;
	 end
  else
  begin
  	casex (D)
  		4'b1000: Y <= 0;//2'b00  1
  		4'bX100: Y <= 1;//2'b01  1
  		4'bXX10: Y <= 2;//2'b10  1
  		4'bXXX1: Y <= 3;//2'b11  1
  	endcase
  	valid <= (~|D)? 1'b0: 1'b1;
  end
end
endmodule