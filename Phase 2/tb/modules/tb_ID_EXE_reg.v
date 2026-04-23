`timescale 1ns/1ps

module tb_ID_EXE_reg;
    reg [31:0] PC_in;
    reg [2:0] aluSrc_in;
    reg [2:0] aluOp_in;
    reg regWrite_in;
    reg memRead_in;
    reg memWrite_in;
    reg memToReg_in;
    reg branch_in;
    reg [31:0] readData1_in;
    reg [31:0] readData2_in;
    reg [63:0] immediate_in;
    reg [4:0] opcode_in;
    reg [5:0] regwriteaddr_in;
    reg clk;
    reg flush;

    wire [31:0] PC_out;
    wire [2:0] aluSrc_out;
    wire [2:0] aluOp_out;
    wire regWrite_out;
    wire memRead_out;
    wire memWrite_out;
    wire memToReg_out;
    wire branch_out;
    wire [31:0] readData1_out;
    wire [31:0] readData2_out;
    wire [63:0] immediate_out;
    wire [4:0] opcode_out;
    wire [5:0] regwriteaddr_out;
    integer fail;

    ID_EXE_reg dut (
        .PC_in(PC_in),
        .aluSrc_in(aluSrc_in),
        .aluOp_in(aluOp_in),
        .regWrite_in(regWrite_in),
        .memRead_in(memRead_in),
        .memWrite_in(memWrite_in),
        .memToReg_in(memToReg_in),
        .branch_in(branch_in),
        .readData1_in(readData1_in),
        .readData2_in(readData2_in),
        .immediate_in(immediate_in),
        .opcode_in(opcode_in),
        .regwriteaddr_in(regwriteaddr_in),
        .clk(clk),
        .flush(flush),
        .PC_out(PC_out),
        .aluSrc_out(aluSrc_out),
        .aluOp_out(aluOp_out),
        .regWrite_out(regWrite_out),
        .memRead_out(memRead_out),
        .memWrite_out(memWrite_out),
        .memToReg_out(memToReg_out),
        .branch_out(branch_out),
        .readData1_out(readData1_out),
        .readData2_out(readData2_out),
        .immediate_out(immediate_out),
        .opcode_out(opcode_out),
        .regwriteaddr_out(regwriteaddr_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        fail = 0;
        flush = 1;

        PC_in = 32'd4;
        aluSrc_in = 3'd1;
        aluOp_in = 3'd2;
        regWrite_in = 1;
        memRead_in = 0;
        memWrite_in = 1;
        memToReg_in = 0;
        branch_in = 1;
        readData1_in = 32'h11;
        readData2_in = 32'h22;
        immediate_in = 64'h33;
        opcode_in = 5'h1F;
        regwriteaddr_in = 6'h2A;

        @(posedge clk);
        if (PC_out !== 0 || regWrite_out !== 0) fail = fail + 1;

        flush = 0;
        @(posedge clk);
        if (PC_out !== 32'd4 || memWrite_out !== 1 || immediate_out !== 64'h33) fail = fail + 1;

        if (fail == 0) $display("tb_ID_EXE_reg PASS");
        else $display("tb_ID_EXE_reg FAIL count=%0d", fail);
        $finish;
    end
endmodule
