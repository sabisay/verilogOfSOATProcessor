module Adder (
    input [7:0] a,
    input [7:0] b,
    output [7:0] result
);
    assign result = a + b;
endmodule

module PCAdder (
    input [7:0] pc_in,
    output [7:0] pc_out
);
    assign pc_out = pc_in + 8'b00000010; // Adds 2 to PC
endmodule