module InstructionMemory (
    input [7:0] address,      // 8-bit adres giri?i
    output [15:0] instruction // 16-bit buyruk ç?k???
);
    reg [15:0] memory [0:127]; // 128 x 16-bit bellek

    initial begin
        // Belle?i ba?lang?ç de?erleri ile yükleyin (iste?e ba?l?)
        // $readmemh("instructions.mem", memory);
    end

    assign instruction = memory[address];
endmodule