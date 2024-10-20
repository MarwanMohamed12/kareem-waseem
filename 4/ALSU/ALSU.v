module ALSU(A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, clk, rst, direction, leds, out);
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
input  clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input  [2:0] opcode;
input signed [2:0] A, B;
output reg [15:0] leds;
output reg signed[5:0] out;

reg red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
reg signed [1:0] cin_reg;
reg [2:0] opcode_reg; 
reg signed [2:0] A_reg, B_reg; //change to signed 
reg signed [5:0] out_next;
wire invalid_red_op, invalid_opcode, invalid;

//Invalid handling
assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
assign invalid = invalid_red_op | invalid_opcode;

//Registering input signals
always @(posedge clk or posedge rst) begin
  if(rst) begin
     cin_reg <= 0;
     red_op_B_reg <= 0;
     red_op_A_reg <= 0;
     bypass_B_reg <= 0;
     bypass_A_reg <= 0;
     direction_reg <= 0;
     serial_in_reg <= 0;
     opcode_reg <= 0;
     A_reg <= 0;
     B_reg <= 0;

  end else begin
     cin_reg <= cin;
     red_op_B_reg <= red_op_B;
     red_op_A_reg <= red_op_A;
     bypass_B_reg <= bypass_B;
     bypass_A_reg <= bypass_A;
     direction_reg <= direction;
     serial_in_reg <= serial_in;
     opcode_reg <= opcode;
     A_reg <= A;
     B_reg <= B;
   
  end
end

//leds output blinking 
always @(posedge clk or posedge rst) begin
  if(rst) begin
     leds <= 0;
  end else begin
      if (invalid)
        leds <= ~leds;
      else
        leds <= 0;
  end
end

//ALSU output processing
always @(posedge clk or posedge rst) begin
 
  if(rst) begin
    out <= 0;
  end
  else begin
    if (bypass_A_reg && bypass_B_reg)
      out <= (INPUT_PRIORITY == "A")? A_reg: B_reg;
    else if (bypass_A_reg)
      out <= A_reg;
    else if (bypass_B_reg)
      out <= B_reg;
    else if (invalid) // cahnge the priority of invalid bits after bypass_reg 
        out <= 0;
    else begin
        case (opcode_reg)
          3'h0: begin //change Opcode to OR not AND
            if (red_op_A_reg && red_op_B_reg)
              out <= (INPUT_PRIORITY == "A")? |A_reg: |B_reg;
            else if (red_op_A_reg) 
              out <= |A_reg;
            else if (red_op_B_reg)
              out <= |B_reg;
            else 
              out <= A_reg | B_reg;
          end
          3'h1: begin // change opcode to XOR not OR
            if (red_op_A_reg && red_op_B_reg)
              out <= (INPUT_PRIORITY == "A")? ^A_reg: ^B_reg;
            else if (red_op_A_reg) 
              out <= ^A_reg;
            else if (red_op_B_reg)
              out <= ^B_reg;
            else 
              out <= A_reg ^ B_reg;
          end
          3'h2: begin //here we add condition to check full adder if ON or OFF
            if(FULL_ADDER == "ON") 
              out <= A_reg + B_reg+cin_reg;
            else if(FULL_ADDER == "OFF") 
              out <= A_reg + B_reg;

          end
          3'h3: out <= A_reg * B_reg;
          3'h4: begin
              
            if (direction_reg)
              out <= {out_next[4:0], serial_in_reg};
            else
              out <= {serial_in_reg, out_next[5:1]};
          end
          3'h5: begin
            if (direction_reg)
              out <= {out_next[4:0], out_next[5]};
            else
              out <= {out_next[0], out_next[5:1]};
          end
        default: out<=out;
        endcase
    end 
  end
  out_next<=out;
end

endmodule