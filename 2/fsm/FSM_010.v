////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: 010-sequence-detector Design 
//
////////////////////////////////////////////////////////////////////////////////
module FSM_010(clk, rst, x, y, users_count);
	parameter IDLE  = 2'b00;
	parameter ZERO  = 2'b01;
	parameter ONE   = 2'b10;
	parameter STORE = 2'b11; 

	input clk, rst, x;
	output y;
	output reg [9:0] users_count;

	reg [1:0] cs, ns;

	always @(*) begin
		case (cs)
			IDLE: 
				if (x)
					ns = IDLE;
				else 
					ns = ZERO;
			ZERO:
				if (x)
					ns = ONE;
				else 
					ns = ZERO;
			ONE: 
				if (x)
					ns = IDLE;
				else 
					ns = STORE;
			STORE: 
				if (x)
					ns = IDLE;
				else 
					ns = ZERO;
			default: 	ns = IDLE;
		endcase
	end

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			cs <= IDLE;
		end
		else begin
			cs <= ns;
		end
	end

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			users_count <= 0;
		end
		else begin
			if (cs == STORE)
				users_count <= users_count + 1;
		end
	end

	assign y = (cs == STORE)? 1:0;

endmodule