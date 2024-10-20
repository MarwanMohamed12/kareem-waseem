interface shift_reg_if ();

  logic serial_in, direction, mode;
  logic [5:0] datain, dataout;
endinterface : shift_reg_if