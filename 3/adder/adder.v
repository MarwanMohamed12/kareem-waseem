module adder (
    input  clk,
    input  reset,
    input  signed [3:0] A,	// Input data A in 2's complement
    input  signed [3:0] B,	// Input data B in 2's complement
    output reg signed [4:0] C // Adder output in 2's complement
		  );

   // Register output C
   always @(posedge clk or posedge reset) begin
      if (reset)
	     C <= 5'b0;
      else
	     C <= A + B;
   end

endmodule
