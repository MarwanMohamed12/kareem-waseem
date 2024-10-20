module my_mem(
input clk,
input write,
input read,
input [7:0] data_in,
input [15:0] address,
output reg [8:0] data_out
);
 // Declare a 9-bit associative array using the logic data type & the key of int datatype
logic [8:0]mem_array[int];

always @(posedge clk) begin
    if (write)
    mem_array[address] = {^data_in, data_in};

    else if (read)
    data_out = mem_array[address];
    else
    mem_array[address]= mem_array[address];
    end
endmodule

