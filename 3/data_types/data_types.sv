module data_types();
int j=1;
int q[$]={0,2,5};


initial begin
q.insert(1,j);
print();
q.delete(1);
print();

q.push_front(7);
print();
q.push_back(9);
print();
j=q.pop_back();
print();
$display("j=%0d",j);
j=q.pop_front();
print();
$display("j=%0d",j);
q.reverse();
print();
q.sort();
print();
q.rsort();
print();
q.shuffle();
print();

end

function void print();
$display("%p",q);
endfunction


endmodule
