module ALU (
    input [7:0] operand1,
    input [7:0] operand2, 
    input [3:0] alu_control,
    input [3:0] shamt,
    output reg [7:0] result,
    output reg [7:0] result_hi,
    output zero
);
    reg[15:0] mul_result;

    always @(*) begin
        case (alu_control)
            4'b0010: result = operand1 + operand2; // Addition
            4'b0110: result = operand1 - operand2; // Subtraction
            4'b0000: result = operand1 & operand2; // AND
            4'b0001: result = operand1 | operand2; // OR
            4'b1001: result = operand1 ^ operand2; // XOR
            4'b1010: result = ~(operand1 | operand2); // NOR
            4'b0111: result = (operand1 < operand2) ? 8'b1 : 8'b0; // SLT
            4'b1000: begin
                mul_result = operand1 * operand2; // Multiplication
                result = mul_result[7:0]; // Lower 8 bits
                result_hi = mul_result[15:8]; // Upper 8 bits
            end
   	//D type uses shamt instead of operand2
            4'b1100: result = operand1 << shamt; // sll
            4'b0011: result = operand1 >> shamt; // srl
            4'b1101: result = operand1 >>> shamt; //sra 

            default: result = 8'b0; // Default case
        endcase
    end

    assign zero = (result == 8'b0);
endmodule

