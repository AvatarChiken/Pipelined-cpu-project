module stage_id (
    input wire [31:0] PC_in,
    input wire [31:0] instruction_in,
    input wire wb_regwrite,
    input wire [4:0] wb_rd,
    input wire [31:0] wb_write_data,
    output wire [31:0] PC_out,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2,
    output wire [63:0] sign_imm,
    output wire [6:0] opcode,
    output wire [3:0] funct,
    output wire [1:0] alusrc,
    output wire [2:0] aluOP,
    output wire regwrite,
    output wire memtoreg,
    output wire memwrite,
    output wire memread,
    output wire branch,
    output wire [4:0] rd,
    input wire clk
);
    main_control main_control_inst(
        .opcode(instruction_in[6:0]),
        .funct3(instruction_in[14:12]),
        .alusrc(alusrc),
        .aluOP(aluOP),
        .regwrite(regwrite),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .memread(memread),
        .branch(branch)
    );

    reg_file reg_file_inst(
        .clk(clk),
        .rs1(instruction_in[19:15]),
        .rs2(instruction_in[24:20]),
        .writereg(wb_rd),
        .writedata(wb_write_data),
        .regwrite(wb_regwrite),
        .readdata1(read_data1),
        .readdata2(read_data2)
    );

    imm_gen imm_gen_inst(
        .instruction(instruction_in),
        .immediate(sign_imm)
    );

    assign opcode = instruction_in[6:0];
    assign funct = {instruction_in[30], instruction_in[14:12]};
    assign PC_out = PC_in;
    assign rd = instruction_in[11:7];
endmodule