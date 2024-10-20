package pack;
    localparam TEST =100,DATA_IN_BITS=8,DATA_OUT_BITS=9,ADDRESS_BITS=16 ;


    class transaction;
        logic write;
        logic read;
        rand bit [DATA_IN_BITS-1:0] data_in;
        rand bit [ADDRESS_BITS-1:0] address;
        logic [DATA_OUT_BITS-1:0] data_out;

        logic [ADDRESS_BITS-1:0] address_array[];
        logic [DATA_IN_BITS-1:0] data_to_write_array[];
        logic [DATA_OUT_BITS-1:0] data_read_expect_assoc[int];
        logic [DATA_OUT_BITS-1:0] data_read_queue[$];

        function new();
            address_array=new[TEST];
            data_to_write_array=new[TEST];
        endfunction

    endclass

endpackage
