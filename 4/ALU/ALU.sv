import pack_file::*;
module ALU_4_bit(if_d.DUT if_t);
   reg signed [4:0]Alu_out;
   // Do the operation
   always @* begin
      case (if_t.Opcode)
      	if_t.Add:     Alu_out = if_t.A + if_t.B;
      	if_t.Sub:     Alu_out = if_t.A - if_t.B;
      	if_t.Not_A:   Alu_out = ~if_t.A;
      	if_t.ReductionOR_B:  Alu_out = |if_t.B;
        default:  Alu_out = 5'b0;
      endcase
   end // always @ *

   // Register output C
   always @(posedge if_t.clk or posedge if_t.reset) begin
      if (if_t.reset)
	     if_t.C <= 5'b0;
      else
	     if_t.C<= Alu_out;
   end

endmodule
