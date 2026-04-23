`timescale 1ns/1ps

module tb_stage_mem;
    reg regwrite;
    reg memtoreg;
    reg memwrite;
    reg memread;
    reg branch;
    reg [31:0] PC_in;
    reg zero;
    reg [63:0] addsum;
    reg [4:0] rd;
    reg [31:0] alu_result;
    reg [31:0] reg_data2;
    reg clk;

    wire [4:0] rd_out;
    wire [31:0] read_data;
    wire [31:0] PC_out;
    wire regwrite_out;
    wire memtoreg_out;
    wire pcsrc_out;
    wire [31:0] branch_target_out;
    wire [31:0] alu_result_out;
    integer fail;

    mem_stage dut (
        .regwrite(regwrite),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .memread(memread),
        .branch(branch),
        .PC_in(PC_in),
        .zero(zero),
        .addsum(addsum),
        .rd(rd),
        .alu_result(alu_result),
        .reg_data2(reg_data2),
        .clk(clk),
        .rd_out(rd_out),
        .read_data(read_data),
        .PC_out(PC_out),
        .regwrite_out(regwrite_out),
        .memtoreg_out(memtoreg_out),
        .pcsrc_out(pcsrc_out),
        .branch_target_out(branch_target_out),
        .alu_result_out(alu_result_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        fail = 0;

        regwrite = 1;
        memtoreg = 1;
        memwrite = 1;
        memread = 0;
        branch = 1;
        zero = 1;
        PC_in = 32'd44;
        addsum = 64'd88;
        rd = 5'd7;
        alu_result = 32'd16;
        reg_data2 = 32'hDEAD_BEEF;

        @(posedge clk);
        memwrite = 0;
        memread = 1;

        @(posedge clk);
        if (read_data !== 32'hDEAD_BEEF) fail = fail + 1;
        if (pcsrc_out !== 1) fail = fail + 1;
        if (branch_target_out !== 32'd88) fail = fail + 1;
        if (rd_out !== 5'd7 || regwrite_out !== 1 || memtoreg_out !== 1) fail = fail + 1;

        if (fail == 0) $display("tb_stage_mem PASS");
        else $display("tb_stage_mem FAIL count=%0d", fail);
        $finish;
    end
endmodule
