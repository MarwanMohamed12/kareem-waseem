module arrays ();

int dyn_arr1[];
int dyn_arr2[]='{9,1,8,3,4,4};

initial begin
    dyn_arr1=new[6];
    foreach(dyn_arr1[i])
        dyn_arr1[i]=i;
    $display("%p %0d",dyn_arr1,dyn_arr1.size());
    dyn_arr1.delete();

    dyn_arr2.reverse();
    $display("%p",dyn_arr2);
    dyn_arr2.sort();
    $display("%p",dyn_arr2);
    dyn_arr2.rsort();
    $display("%p",dyn_arr2);
    dyn_arr2.shuffle();
    $display("%p",dyn_arr2);
end

endmodule
