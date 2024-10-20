module Asseritions(ALSU_if if_t);
bit invalid;
import constant_enums::*;

assign invalid=(if_t.opcode==INVALID6 || if_t.opcode==INVALID7) || ((if_t.opcode>3'b001) && (if_t.red_op_A|if_t.red_op_B));

always_comb begin 
    if(if_t.rst)begin
        rst_check:assert final(if_t.out==0 && if_t.leds==0);
    end 
end

property leds;
@(posedge if_t.clk) disable iff( if_t.rst ) (invalid) |=> ##1 if_t.leds == ~ $past(if_t.leds) ;
endproperty

property rst_n;
@(posedge if_t.clk) disable iff( if_t.rst ) (invalid) |=> ##1 ( if_t.out ==0 );
endproperty

// BYPASS CHECK
property bypass1;
  @(posedge if_t.clk) disable iff(if_t.rst)
    (if_t.bypass_A && if_t.bypass_B && if_t.INPUT_PRIORITY == "A") |=> ##1 if_t.out == $past(if_t.A, 2) ;
endproperty

property bypass2;
  @(posedge if_t.clk) disable iff(if_t.rst)
      (if_t.bypass_A && if_t.bypass_B && if_t.INPUT_PRIORITY == "B") |=> ##1 if_t.out == $past(if_t.B, 2) ;
endproperty

property bypass3;
  @(posedge if_t.clk) disable iff(if_t.rst)
    (if_t.bypass_A && !if_t.bypass_B) |=> ##1 if_t.out == $past(if_t.A, 2)  ;
endproperty

property bypass4;
  @(posedge if_t.clk) disable iff(if_t.rst)
    (!if_t.bypass_A && if_t.bypass_B) |=> ##1 if_t.out == $past(if_t.B, 2) ;
endproperty

//------------INVALID CHECK-----------------------//

property INVALID_ch;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && invalid  ) |=> ##1
      (if_t.out == 0 ) ;
endproperty

//--------------------------------------------//

//--------------------------------------------//


//------------OR CHECK-----------------------//

property OR_RedOp_1;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==OR && if_t.red_op_A &&if_t. red_op_B && if_t.INPUT_PRIORITY == "A") |=> ##1
      (if_t.out == |$past(if_t.A, 2)) ;
endproperty

property OR_RedOp_2;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==OR && if_t.red_op_A && if_t.red_op_B && if_t.INPUT_PRIORITY == "B") |=> ##1
      (if_t.out == |$past(if_t.B, 2)) ;
endproperty

property OR_RedOp_3;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==OR && if_t.red_op_A && !if_t.red_op_B) |=> ##1
      (if_t.out == |$past(if_t.A, 2)) ;
endproperty

property OR_RedOp_4;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==OR && !if_t.red_op_A && if_t.red_op_B ) |=> ##1
      (if_t.out == |$past(if_t.B, 2)) ;
endproperty

property OR_check;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==OR && !if_t.red_op_A && !if_t.red_op_B ) |=> ##1
      (if_t.out == $past(if_t.A, 2) | $past(if_t.B, 2)) ;
endproperty

//--------------------------------------------//


//------------XOR CHECK-----------------------//

property XOR_RedOp_1;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==XOR && if_t.red_op_A &&if_t. red_op_B && if_t.INPUT_PRIORITY == "A") |=> ##1
      (if_t.out == ^$past(if_t.A, 2)) ;
endproperty

property XOR_RedOp_2;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==XOR && if_t.red_op_A && if_t.red_op_B && if_t.INPUT_PRIORITY == "B") |=> ##1
      (if_t.out == ^$past(if_t.B, 2)) ;
endproperty

property XOR_RedOp_3;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==XOR && if_t.red_op_A && !if_t.red_op_B) |=> ##1
      (if_t.out == ^$past(if_t.A, 2)) ;
endproperty

property XOR_RedOp_4;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==XOR && !if_t.red_op_A && if_t.red_op_B ) |=> ##1
      (if_t.out == ^$past(if_t.B, 2)) ;
endproperty

property XOR_check;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==XOR && !if_t.red_op_A && !if_t.red_op_B ) |=> ##1
      (if_t.out == $past(if_t.A, 2) ^ $past(if_t.B, 2)) ;
endproperty

//--------------------------------------------//


//------------ADD CHECK-----------------------//

property fullAdd;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==ADD && if_t.FULL_ADDER == "ON") |=> ##1
      (if_t.out == $past(if_t.A, 2) + $past(if_t.B, 2) + $past(if_t.cin, 2)) ;
endproperty

property halfAdd;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==ADD && if_t.FULL_ADDER == "OFF") |=> ##1
      (if_t.out == $past(if_t.A, 2) + $past(if_t.B, 2) ) ;
endproperty

//--------------------------------------------//


//------------multiply CHECK-----------------------//

property multiply;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==MULT ) |=> ##1
      (if_t.out == $past(if_t.A, 2) * $past(if_t.B, 2) ) ;
endproperty

//--------------------------------------------//


//------------shift CHECK-----------------------//

property shift_right;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==SHIFT && if_t.direction==0 ) |=> ##1
        (if_t.out =={ $past(if_t.serial_in,2) , $past(if_t.out[5:1]) } ) ;
endproperty

property shift_left;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==SHIFT && if_t.direction==1 ) |=> ##1
        (if_t.out =={$past(if_t.out[4:0]) , $past(if_t.serial_in,2) } ) ;
endproperty

//--------------------------------------------//

//------------Rotate CHECK-----------------------//

property rotate_right;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==ROTATE && if_t.direction==0 ) |=> ##1
        (if_t.out =={$past(if_t.out[0]) , $past(if_t.out[5:1]) } ) ;
endproperty

property rotate_left;
@(posedge if_t.clk) disable iff(if_t.rst) 
    (!if_t.bypass_A && !if_t.bypass_B && !invalid && if_t.opcode==ROTATE && if_t.direction==1 ) |=> ##1
        (if_t.out =={$past(if_t.out[4:0]) , $past(if_t.out[5])} ) ;
endproperty

//--------------------------------------------//

leds_check:assert property(leds);
// bypass assertions 
bypass1_check:assert property(bypass1);
bypass2_check:assert property(bypass2);
bypass3_check:assert property(bypass3);
bypass4_check:assert property(bypass4);

// bypass assertions 
INVALID_check:assert property(INVALID_ch);

// Opcode assertions 

//---------------------------------------//
//OR CHECK
OR1_check:assert property(OR_RedOp_1);
OR2_check:assert property(OR_RedOp_2);
OR3_check:assert property(OR_RedOp_3);
OR4_check:assert property(OR_RedOp_4);
OR5_check:assert property(OR_check);

//---------------------------------------//
//XOR CHECK
XOR1_check:assert property(XOR_RedOp_1);
XOR2_check:assert property(XOR_RedOp_2);
XOR3_check:assert property(XOR_RedOp_3);
XOR4_check:assert property(XOR_RedOp_4);
XOR5_check:assert property(XOR_check);

//---------------------------------------//
//ADD CHECK
FullADD_check:assert property(fullAdd)else $display("A=%0d B=%0d cin=%0d and out=%0d ",$past(if_t.A, 2) , $past(if_t.B, 2) , $past(if_t.cin, 2),($past(if_t.A, 2) + $past(if_t.B, 2)+$past(if_t.cin, 2)));;
halfADD_check:assert property(halfAdd);

//---------------------------------------//
//Multiply CHECK
MULT_check:assert property(multiply);

//---------------------------------------//
//shift CHECK
shift_R_check:assert property(shift_right) ;
shift_L_check:assert property(shift_left);

//---------------------------------------//
//shift CHECK
rotate_R_check:assert property(rotate_right);
rotate_L_check:assert property(rotate_left);



//-----------------------------------cover----------------------------------------//
leds_cover:cover property(leds);


//bypass cover
bypass1_cover:cover property(bypass1);
bypass2_cover:cover property(bypass2);
bypass3_cover:cover property(bypass3);
bypass4_cover:cover property(bypass4);

//INVALID cover
INVALID_cover:cover property(INVALID_ch);

//opcode cover OR
OR1_cover:cover property(OR_RedOp_1);
OR2_cover:cover property(OR_RedOp_2);
OR3_cover:cover property(OR_RedOp_3);
OR4_cover:cover property(OR_RedOp_4);
OR5_cover:cover property(OR_check);

//opcode cover XOR
XOR1_cover:cover property(XOR_RedOp_1);
XOR2_cover:cover property(XOR_RedOp_2);
XOR3_cover:cover property(XOR_RedOp_3);
XOR4_cover:cover property(XOR_RedOp_4);
XOR5_cover:cover property(XOR_check);

//opcode cover ADD
FullADD_cover:cover property(fullAdd);
halfADD_cover:cover property(halfAdd);

//opcode cover mult
Mult_cover:cover property(multiply);

//opcode cover shift
shiftL_cover:cover property(shift_left);
shiftR_cover:cover property(shift_right);

//opcode cover rotate
rotateLeft_cover:cover property(rotate_left);
rotateRight_cover:cover property(rotate_right);

// -----------------------------------end cover-------------------------------------//
endmodule