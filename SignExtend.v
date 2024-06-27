module SignExtend (
    input [5:0] in, // 6-bit input
    output [7:0] out // 8-bit output
);
    assign out = {{2{in[5]}}, in}; // Sign-extend from 6-bit to 8-bit
endmodule
