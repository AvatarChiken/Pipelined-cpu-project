module riscv_core (
    input wire clk,
    input wire rst
);
wire [31:0] pc_if;
wire [31:0] instruction_if;

wire [31:0] pc_id;
wire [31:0] read_data1_id;
wire [31:0] read_data2_id;
wire [63:0] sign_imm_id;
wire [6:0] opcode_id;
wire [3:0] funct_id;
wire [1:0] alusrc_id;
wire [2:0] aluOP_id;
wire regwrite_id;
wire memtoreg_id;
wire memwrite_id;
wire memread_id;
wire branch_id;
wire [4:0] rd_id;

wire [31:0] pc_exe;
wire [31:0] alu_result_exe;
wire regwrite_exe;
wire memtoreg_exe;
wire memwrite_exe;
wire memread_exe;
wire branch_exe;
wire [4:0] rd_exe;
wire zero_exe;
wire [31:0] reg_data2_exe;
wire [63:0] addsum_exe;

wire [4:0] rd_mem;
wire [31:0] read_data_mem;
wire [31:0] pc_mem;
wire regwrite_mem;
wire memtoreg_mem;
wire pcsrc_mem;
wire [31:0] branch_target_mem;
wire [31:0] alu_result_mem;

wire regwrite_wb;
wire [4:0] rd_wb;
wire [31:0] write_data_wb;

stage_if if_stage (
    .PCsrc(pcsrc_mem),
    .fromex_mem(branch_target_mem),
    .clk(clk),
    .rst(rst),
    .stall(1'b0),
    .PC(pc_if),
    .instruction(instruction_if)
);

stage_id id_stage (
    .PC_in(pc_if),
    .instruction_in(instruction_if),
    .wb_regwrite(regwrite_wb),
    .wb_rd(rd_wb),
    .wb_write_data(write_data_wb),
    .PC_out(pc_id),
    .read_data1(read_data1_id),
    .read_data2(read_data2_id),
    .sign_imm(sign_imm_id),
    .opcode(opcode_id),
    .funct(funct_id),
    .alusrc(alusrc_id),
    .aluOP(aluOP_id),
    .regwrite(regwrite_id),
    .memtoreg(memtoreg_id),
    .memwrite(memwrite_id),
    .memread(memread_id),
    .branch(branch_id),
    .rd(rd_id),
    .clk(clk)
);

exe_stage exe_stage_inst (
    .aluOP(aluOP_id),
    .alusrc(alusrc_id),
    .regwrite(regwrite_id),
    .memtoreg(memtoreg_id),
    .memwrite(memwrite_id),
    .memread(memread_id),
    .branch(branch_id),
    .PC_in(pc_id),
    .read_data1(read_data1_id),
    .read_data2(read_data2_id),
    .sign_imm(sign_imm_id),
    .funct(funct_id),
    .rd(rd_id),
    .PC_out(pc_exe),
    .alu_result(alu_result_exe),
    .regwrite_out(regwrite_exe),
    .memtoreg_out(memtoreg_exe),
    .memwrite_out(memwrite_exe),
    .memread_out(memread_exe),
    .branch_out(branch_exe),
    .rd_out(rd_exe),
    .zero(zero_exe),
    .reg_data2_out(reg_data2_exe),
    .addsum(addsum_exe)
);

mem_stage mem_stage_inst (
    .regwrite(regwrite_exe),
    .memtoreg(memtoreg_exe),
    .memwrite(memwrite_exe),
    .memread(memread_exe),
    .branch(branch_exe),
    .PC_in(pc_exe),
    .zero(zero_exe),
    .addsum(addsum_exe),
    .rd(rd_exe),
    .alu_result(alu_result_exe),
    .reg_data2(reg_data2_exe),
    .clk(clk),
    .rd_out(rd_mem),
    .read_data(read_data_mem),
    .PC_out(pc_mem),
    .regwrite_out(regwrite_mem),
    .memtoreg_out(memtoreg_mem),
    .pcsrc_out(pcsrc_mem),
    .branch_target_out(branch_target_mem),
    .alu_result_out(alu_result_mem)
);

stage_wb wb_stage (
    .memtoreg(memtoreg_mem),
    .regwrite_in(regwrite_mem),
    .rd_in(rd_mem),
    .read_data_in(read_data_mem),
    .alu_result_in(alu_result_mem),
    .regwrite_out(regwrite_wb),
    .rd_out(rd_wb),
    .write_data(write_data_wb)
);
endmodule