////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Shift register Design 
// 
////////////////////////////////////////////////////////////////////////////////
module shift_reg (shift_reg_if if_t);


always @(*) begin

      if (if_t.mode) // rotate
         if (if_t.direction) // left
            if_t.dataout = {if_t.datain[4:0], if_t.datain[5]};
         else
            if_t.dataout = {if_t.datain[0], if_t.datain[5:1]};
      else // shift
         if (if_t.direction) // left
            if_t.dataout = {if_t.datain[4:0], if_t.serial_in};
         else
            if_t.dataout = {if_t.serial_in, if_t.datain[5:1]};
end
endmodule