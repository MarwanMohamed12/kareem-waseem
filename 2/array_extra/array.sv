module  array ();

bit [11:0] my_array[4];

initial begin
    my_array[0] = 12'h012; // 0000_0001_0010
    my_array[1] = 12'h345; // 0011_0100_0101
    my_array[2] = 12'h678; // 0110_0111_1000
    my_array[3] = 12'h9AB; // 1001_1010_1011

    foreach(my_array[i])
    $display("bit number 5,4=%b",my_array[i][5:4]);

    for(int i=0;i<$size(my_array);i++)begin
        $displayb(my_array[i][5:4]);
    end
end
    
endmodule
