module priority_enc (if_pe.DUT if_t);

always @(posedge if_t.clk) begin
  if (if_t.rst) begin
     if_t.Y <= 2'b0;
	 if_t.valid<=1'b0;
	 end
  else
  begin
  	casex (if_t.D)
  		4'b1000: if_t.Y <= 0;//2'b00  1
  		4'bX100: if_t.Y <= 1;//2'b01  1
  		4'bXX10: if_t.Y <= 2;//2'b10  1
  		4'bXXX1: if_t.Y <= 3;//2'b11  1
  	endcase
  	if_t.valid <= (~|if_t.D)? 1'b0: 1'b1; 
  end
end
endmodule