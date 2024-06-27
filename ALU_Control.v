module ALUControl (
    input [3:0] opcode,
    input [2:0] funct,
    output reg [3:0] ALUOp
);
    always @(*) begin
        case (opcode)
            4'b0000: begin // R-type instructions
                case (funct)
                    3'b000: ALUOp = 4'b0010; // add
                    3'b001: ALUOp = 4'b0000; // and
                    3'b010: ALUOp = 4'b0110; // sub
                    3'b011: ALUOp = 4'b0001; // or
                    3'b100: ALUOp = 4'b1001; // xor
                    3'b101: ALUOp = 4'b1010; // nor
                    3'b110: ALUOp = 4'b0111; // slt
                    3'b111: ALUOp = 4'bXXXX; // jr (handled separately in control unit)
                    default: ALUOp = 4'b0000; // default to and
                endcase
            end
            4'b0001: ALUOp = 4'b1000; // mul
            4'b0010: ALUOp = 4'bXXXX; // mfhi (handled separately in control unit)
            4'b0011: ALUOp = 4'bXXXX; // mflo (handled separately in control unit)
            4'b0010: ALUOp = 4'b0010; // addi
            4'b0011: ALUOp = 4'b0000; // andi
            4'b0100: ALUOp = 4'b0001; // ori
            4'b0101: ALUOp = 4'b1000; // muli
            4'b0110: ALUOp = 4'b0110; // beq
            4'b0111: ALUOp = 4'b0110; // bne
            4'b1000: ALUOp = 4'b0111; // slti
            4'b1001: ALUOp = 4'b0010; // lw
            4'b1010: ALUOp = 4'b0010; // sw
            4'b1011: ALUOp = 4'bXXXX; // jump (handled separately in control unit)
            4'b1100: ALUOp = 4'bXXXX; // jal (handled separately in control unit)
            4'b1101: begin // D-type instructions
                case (funct)
                    3'b000: ALUOp = 4'b1100; // sll
                    3'b001: ALUOp = 4'b0011; // srl
                    3'b010: ALUOp = 4'b1101; // sra
                    default: ALUOp = 4'b0000; // default to and
                endcase
            end
            default: ALUOp = 4'b0000; // default to and
        endcase
    end
endmodule
