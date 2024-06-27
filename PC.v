module PC (
    input clk,
    input reset,
    input [7:0] next_pc,
    output reg [7:0] pc// 8 bit size pc and pc_next
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 8'b0; //pc=0
        else
            pc <= next_pc; 
    end
endmodule
