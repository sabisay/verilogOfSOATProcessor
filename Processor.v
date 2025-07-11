module CPU (
    input clk,
    input reset
);
    wire [7:0] pc, next_pc, pc_plus_2, branch_addr, jump_addr, sign_ext_out, alu_result, mem_data, reg_data1, reg_data2, alu_operand2, write_register, write_data,reg_dst_result;
    wire [15:0] instruction;
    wire [3:0] alu_op, reg_write_addr;
    wire [2:0] funct;
    wire zero, reg_dst, jump, jump_and_link, branch, mem_read, mem_write, mem_to_reg, alu_src, reg_write, mfhilo;
    wire pc_src, branch_taken;
    
    // Instantiate PC
    PC pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );
    
    // Instantiate Instruction Memory
    InstructionMemory inst_mem_inst (
        .address(pc),
        .instruction(instruction)
    );
    
    // Decode instruction fields
    assign reg_write_addr = (reg_dst) ? instruction[11:8] : instruction[3:0];
    assign funct = instruction[2:0];
    
    // Instantiate Control Unit
    ControlUnit control_unit_inst (
        .opcode(instruction[15:12]),
        .funct(funct),
        .RegDst(reg_dst),
        .Jump(jump),
        .JumpAndLink(jump_and_link),
        .Branch(branch),
        .MemRead(mem_read),
        .MemWrite(mem_write),
        .MemtoReg(mem_to_reg),
        .ALUOp(alu_op),
        .ALUSrc(alu_src),
        .RegWrite(reg_write),
        .MfhiLo_(mfhilo)
    );
    
    // Instantiate Register File
    RegisterFile reg_file_inst (
        .clk(clk),
        .read_reg1(instruction [11:9]),
        .read_reg2(instruction[8:6]),
        .write_reg(reg_write_addr),
        .write_data(write_data),
        .reg_write(reg_write),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );
    
    // Instantiate Sign Extend
    SignExtend sign_extend_inst (
        .in(instruction[5:0]),
        .out(sign_ext_out)
    );
    
    // Select ALU operand
    Mux2to1 alu_src_mux (
        .in0(reg_data2),
        .in1(sign_ext_out),
        .sel(alu_src),
        .out(alu_operand2)
    );

 // Select rt or rd
    Mux2to1 rt_rd_mux (
        .in0(instruction[8:6]),
        .in1(instruction[5:3]),
        .sel(reg_dst),
        .out(reg_dst_result)
    );
     // Select ra or reg
    Mux2to1 reg_ra_mux (
        .in0(reg_dst_result),
        .in1(registers[7]),//yedinci register nas?l eri?ilecek???
        .sel(jump_and_link),
        .out(write_register)
    );

    // Instantiate ALU
    ALU alu_inst (
        .operand1(reg_data1),
        .operand2(alu_operand2),
        .alu_control(alu_op),
        .shamt(instruction[8:6]),
        .result(alu_result),
        .result_hi(), // E?er istenirse kullanabilirsiniz
        .zero(zero)
    );
    
    // Instantiate Data Memory
    DataMemory data_mem_inst (
        .clk(clk),
        .address(alu_result),
        .write_data(reg_data2),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(mem_data)
    );
    
    // Select memory or ALU result
    Mux2to1 mem_to_reg_mux (
        .in0(alu_result),
        .in1(mem_data),
        .sel(mem_to_reg),
        .out(write_data)
    );
    
    // PC + 2 adder
    PCAdder pc_adder_inst (
        .pc_in(pc),
        .pc_out(pc_plus_2)
    );
    
    // Branch address calculation
    assign branch_addr = pc_plus_2 + (sign_ext_out << 1);
    
    // Jump address calculation
    assign jump_addr = instruction[7:0];
    
    // Branch taken logic
    assign branch_taken = (branch & zero) | (branch & ~zero);
    
    // Next PC logic
    assign pc_src = jump | (branch & branch_taken);
    assign next_pc = (pc_src) ? ((jump) ? jump_addr : branch_addr) : pc_plus_2;
    
    // Handle Jump and Link (JAL) instruction
    always @(posedge clk) begin
        if (jump_and_link)
            reg_file_inst.registers[7] <= pc_plus_2; // $ra register
    end
    
    // Handle mfhi and mflo instructions
    always @(posedge clk) begin
        if (mfhilo) begin
            if (funct == 3'b100)
                reg_file_inst.registers[7] <= alu_inst.result_hi; // mfhi
            else if (funct == 3'b101)
                reg_file_inst.registers[7] <= alu_inst.result; // mflo
        end
    end

endmodule
