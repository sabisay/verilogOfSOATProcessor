module RegisterFile (
    input clk,
    input [3:0] read_reg1,
    input [3:0] read_reg2,
    input [3:0] write_reg,// 11 register için 4 bitlik adresleme 2^4=16
    input [7:0] write_data, 
    input reg_write,
    output [7:0] read_data1,
    output [7:0] read_data2
);
    reg [7:0] registers [0:10]; // 11 adet 8-bit geni?likte register

    // Registerlar?n ilk de?erleri 0  
    initial begin
        registers[0] = 8'b0;  // $zero
        registers[1] = 8'b0;  // $t0
        registers[2] = 8'b0;  // $t1
        registers[3] = 8'b0;  // $t2
        registers[4] = 8'b0;  // $t3
        registers[5] = 8'b0;  // $s0
        registers[6] = 8'b0;  // $s1
        registers[7] = 8'b0;  // $ra
        registers[8] = 8'b0;  // Hi
        registers[9] = 8'b0;  // Lo
        registers[10] = 8'b0; // sp
    end

    always @(posedge clk) begin
        if (reg_write)
            registers[write_reg] <= write_data;
    end
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];
endmodule
