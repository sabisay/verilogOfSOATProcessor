module DataMemory (
    input clk,
    input [7:0] address,      // 8-bit adres giri?i
    input [7:0] write_data,   // 8-bit yazma verisi
    input mem_write,          // Belle?e yazma sinyali
    input mem_read,           // Bellekten okuma sinyali
    output [7:0] read_data    // 8-bit okuma verisi
);
    reg [7:0] memory [0:255]; // 256 x 8-bit bellek

    always @(posedge clk) begin
        if (mem_write)
            memory[address] <= write_data;
    end

    assign read_data = (mem_read) ? memory[address] : 8'bz;
endmodule