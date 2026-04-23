`timescale 1ns/1ps

module tb_stage_exe;
    reg [1:0] aluOP;
    reg [1:0] alusrc;
    reg regwrite;
    reg memtoreg;
    reg memwrite;
    reg memread;
    reg branch;
    reg [31:0] PC_in;
    reg [31:0] read_data1;
    reg [31:0] read_data2;
    reg [63:0] sign_imm;
    reg [3:0] funct;
    reg [4:0] rd;

    wire [31:0] PC_out;
    wire [31:0] alu_result;
    wire regwrite_out;
    wire memtoreg_out;
    wire memwrite_out;
    wire memread_out;
    wire branch_out;
    wire [4:0] rd_out;
    wire zero;
    wire [31:0] reg_data2_out;
    wire [63:0] addsum;
    integer fail;

    exe_stage dut (
        .aluOP(aluOP),
        .alusrc(alusrc),
        .regwrite(regwrite),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .memread(memread),
        .branch(branch),
        .PC_in(PC_in),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .sign_imm(sign_imm),
        .funct(funct),
        .rd(rd),
        .PC_out(PC_out),
        .alu_result(alu_result),
        .regwrite_out(regwrite_out),
        .memtoreg_out(memtoreg_out),
        .memwrite_out(memwrite_out),
        .memread_out(memread_out),
        .branch_out(branch_out),
        .rd_out(rd_out),
        .zero(zero),
        .reg_data2_out(reg_data2_out),
        .addsum(addsum)
    );

    initial begin
        fail = 0;

        aluOP = 2'b10;
        alusrc = 2'b00;
        regwrite = 1;
        memtoreg = 0;
        memwrite = 0;
        memread = 0;
        branch = 0;
        PC_in = 32'd100;
        read_data1 = 32'd7;
        read_data2 = 32'd5;
        sign_imm = 64'd4;
        funct = 4'b0000;
        rd = 5'd9;
        #1;

        if (alu_result !== 32'd12) fail = fail + 1;
        if (addsum[31:0] !== 32'd104) fail = fail + 1;
        if (rd_out !== 5'd9 || regwrite_out !== 1) fail = fail + 1;

        aluOP = 2'b01;
        #1;
        if (alu_result !== 32'd2 || zero !== 0) fail = fail + 1;

        if (fail == 0) $display("tb_stage_exe PASS");
        else $display("tb_stage_exe FAIL count=%0d", fail);
        $finish;
    end
endmodule
