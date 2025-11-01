module processor (
    input clk,
    input rst
);
    // Internal Signals
    wire [31:0] pc_out, pc_in, instr;
    wire [31:0] read_data1, read_data2, alu_result, alu_b, mem_read_data , write_data;
    wire [1:0] result_src, imm_src, alu_op;
    wire reg_write, alu_src, mem_write, branch, pc_src, jump;
    wire [2:0] alu_control;
    wire [31:0] imm_out;
    wire zero;

    // Program Counter
    pc_system pc_unit (clk, rst, pc_src, imm_out, pc_out);

    // Instruction Memory (ICache)
    instruction_memory instr_mem (pc_out, instr);

    // Control Unit
    controlUnit ctrl_unit (instr[6:0], instr[14:12], instr[30], zero, pc_src, result_src, mem_write, alu_src, imm_src, reg_write, alu_op, alu_control);

    // Register File
    regfile rf (instr[19:15], instr[24:20], instr[11:7],read_data1, read_data2 , write_data, clk, reg_write, rst);

    // ALU
    ALU alu (read_data1, alu_b, alu_control, alu_result, zero);

    // MUX for ALUSrc
    mux1 alu_mux (read_data2, imm_out, alu_src, alu_b);

    // MUX for ResultSrca
    mux3 result_mux (alu_result, mem_read_data, (pc_out + 4), result_src, write_data);

    // Data Memory
    data_memory data_mem (clk, rst, mem_write, alu_result, read_data2, mem_read_data);

    // ImmExtender
    extender imm_ext (imm_src, instr, imm_out);

endmodule
