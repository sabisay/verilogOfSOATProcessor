module ControlUnit (
    input [3:0] opcode,
    input [2:0] funct,
    output reg RegDst,
    output reg Jump,
    output reg JumpAndLink,
    output reg Branch,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg [3:0] ALUOp,
    output reg ALUSrc,
    output reg RegWrite,
    output reg MfhiLo_
);
    always @(*) begin
        // Default values
        RegDst = 0;
        Jump = 0;
        JumpAndLink = 0;
        Branch = 0;
        MemRead = 0;
        MemWrite = 0;
        MemtoReg = 0;
        ALUOp = 4'b0000;
        ALUSrc = 0;
        RegWrite = 0;
        MfhiLo_ = 0;
        
        case (opcode)
            4'b0000: begin // R-type instructions
                case (funct)
                    3'b000: begin // add
                        RegDst = 1;
                        RegWrite = 1;
                        ALUOp = 4'b0010;
                    end
                    3'b001: begin // sub
                        RegDst = 1;
                        RegWrite = 1;
                        ALUOp = 4'b0110;
                    end
                    3'b010: begin // and
                        RegDst = 1;
                        RegWrite = 1;
                        ALUOp = 4'b0000;
                    end
                    3'b011: begin // or
                        RegDst = 1;
                        RegWrite = 1;
                        ALUOp = 4'b0001;
                    end
                    3'b100: begin // xor
                        RegDst = 1;
                        RegWrite = 1;
                        ALUOp = 4'b1001;
                    end
                    3'b101: begin // nor
                        RegDst = 1;
                        RegWrite = 1;
                        ALUOp = 4'b1010;
                    end
                    3'b110: begin // slt
                        RegDst = 1;
                        RegWrite = 1;
                        ALUOp = 4'b0111;
                    end
                    3'b111: begin // mul
                        RegDst = 1;
                        RegWrite = 1;
                        ALUOp = 4'b1000;
                    end
                    3'b100: begin // mfhi
                        RegWrite = 1;
                        MfhiLo_ = 1;
                    end
                    3'b101: begin // mflo
                        RegWrite = 1;
                        MfhiLo_ = 0;
                    end
                    default: begin
                        // Handle undefined funct values
                    end
                endcase
            end
            4'b0001: begin // addi
                ALUSrc = 1;
                RegWrite = 1;
                ALUOp = 4'b0010;
            end
            4'b0010: begin // andi
                ALUSrc = 1;
                RegWrite = 1;
                ALUOp = 4'b0000;
            end
            4'b0011: begin // ori
                ALUSrc = 1;
                RegWrite = 1;
                ALUOp = 4'b0001;
            end
            4'b0100: begin // muli
                ALUSrc = 1;
                RegWrite = 1;
                ALUOp = 4'b1000;
            end
            4'b0101: begin // slti
                ALUSrc = 1;
                RegWrite = 1;
                ALUOp = 4'b0111;
            end
            4'b0110: begin // lw
                ALUSrc = 1;
                MemRead = 1;
                MemtoReg = 1;
                RegWrite = 1;
                ALUOp = 4'b0010;
            end
            4'b0111: begin // sw
                ALUSrc = 1;
                MemWrite = 1;
                ALUOp = 4'b0010;
            end
            4'b1000: begin // beq
                Branch = 1;
                ALUOp = 4'b0110;
            end
            4'b1001: begin // bne
                Branch = 1;
                ALUOp = 4'b0110;
            end
            4'b1010: begin // jump
                Jump = 1;
            end
            4'b1011: begin // jal
                Jump = 1;
                JumpAndLink = 1;
            end
            4'b1100: begin // jr
                // No control signal needs to be set
            end
            4'b1101: begin // D-type instructions
                case (funct)
                    3'b000: begin // sll
                        RegDst = 1;
                        RegWrite = 1;
                        ALUOp = 4'b1100;
                    end
                    3'b001: begin // srl
                        RegDst = 1;
                        RegWrite = 1;
                        ALUOp = 4'b1101;
                    end
                    3'b010: begin // sra
                        RegDst = 1;
                        RegWrite = 1;
                        ALUOp = 4'b1110;
                    end
                    default: begin
                        // Handle undefined funct values
                    end
                endcase
            end
            default: begin
                // Handle undefined opcode values
            end
        endcase
    end
endmodule
