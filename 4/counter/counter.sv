////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////

module counter (if_counter.DUT if_t);

always @(posedge if_t.clk or negedge if_t.rst_n) begin
    if (!if_t.rst_n)
        if_t.count_out <= 0;
    else if (!if_t.load_n)
        if_t.count_out <= if_t.data_load;
    else if (if_t.ce)
        if (if_t.up_down)
            if_t.count_out <= if_t.count_out + 1;
        else 
            if_t.count_out <= if_t.count_out - 1;
end

assign if_t.max_count = (if_t.count_out == {if_t.WIDTH{1'b1}})? 1:0;
assign if_t.zero = (if_t.count_out == 0)? 1:0;

endmodule