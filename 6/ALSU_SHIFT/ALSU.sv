module ALSU(ALSU_if if_t);

reg red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
reg signed [1:0] cin_reg;
reg [2:0] opcode_reg; 
reg signed [2:0] A_reg, B_reg; //change to signed 
reg signed [5:0] out_next;
wire invalid_red_op, invalid_opcode, invalid;

reg signed [5:0]out_shift_reg;

//Invalid handling
assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
assign invalid = invalid_red_op | invalid_opcode;



//Registering input signals
always @(posedge if_t.clk or posedge if_t.rst) begin
  if(if_t.rst) begin
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
     cin_reg <= if_t.cin;
     red_op_B_reg <= if_t.red_op_B;
     red_op_A_reg <= if_t.red_op_A;
     bypass_B_reg <= if_t.bypass_B;
     bypass_A_reg <= if_t.bypass_A;
     direction_reg <= if_t.direction;
     serial_in_reg <= if_t.serial_in;
     opcode_reg <= if_t.opcode;
     A_reg <= if_t.A;
     B_reg <= if_t.B;
   
  end
end

//leds output blinking 
always @(posedge if_t.clk or posedge if_t.rst) begin
  if(if_t.rst) begin
     if_t.leds <= 0;
  end else begin
      if (invalid)
        if_t.leds <= ~if_t.leds;
      else
        if_t.leds <= 0;
  end
end

//ALSU output processing
always @(posedge if_t.clk or posedge if_t.rst) begin
 
  if(if_t.rst) begin
    if_t.out <= 0;
  end
  else begin
    if (bypass_A_reg && bypass_B_reg)
      if_t.out <= (if_t.INPUT_PRIORITY == "A")?A_reg: B_reg;
    else if (bypass_A_reg)
      if_t.out <= A_reg;
    else if (bypass_B_reg)
      if_t.out <= B_reg;
    else if (invalid) // cahnge the priority of invalid bits after bypass_reg 
        if_t.out <= 0;
    else begin
        case (opcode_reg)
          3'h0: begin //change Opcode to OR not AND
            if (red_op_A_reg && red_op_B_reg)
              if_t.out <= (if_t.INPUT_PRIORITY == "A")? |A_reg: |B_reg;
            else if (red_op_A_reg) 
              if_t.out <= |A_reg;
            else if (red_op_B_reg)
              if_t.out <= |B_reg;
            else 
              if_t.out <= A_reg | B_reg;
          end
          3'h1: begin // change opcode to XOR not OR
            if (red_op_A_reg && red_op_B_reg)
              if_t.out <= (if_t.INPUT_PRIORITY == "A")? ^A_reg: ^B_reg;
            else if (red_op_A_reg) 
              if_t.out <= ^A_reg;
            else if (red_op_B_reg)
              if_t.out <= ^B_reg;
            else 
              if_t.out <= A_reg ^ B_reg;
          end
          3'h2: begin //here we add condition to check full adder if ON or OFF
            if(if_t.FULL_ADDER == "ON") 
              if_t.out <= A_reg + B_reg+cin_reg;
            else if(if_t.FULL_ADDER == "OFF") 
              if_t.out <= A_reg + B_reg;
            

          end
          3'h3: if_t.out <= A_reg * B_reg;
          3'h4: begin //100
              if_t.out <= out_shift_reg;
          end
          3'h5: begin//101        
              if_t.out <= out_shift_reg;
          end
        default: if_t.out<=if_t.out;
        endcase
    end 
  end
  out_next<=if_t.out;
end

endmodule