`timescale 1ns/1ps

module tb_exe_mem_reg;
    reg clk;
    reg flush;
    reg memwrite_in;
    reg memread_in;
    reg regwrite_in;
    reg memtoreg_in;
    reg [31:0] alu_result_in;
    reg zero;
    reg [31:0] reg_data2_in;
    reg [63:0] addsum_in;
    reg [4:0] rd_in;

    wire memwrite_out;
    wire memread_out;
    wire regwrite_out;
    wire memtoreg_out;
    wire [31:0] alu_result_out;
    wire zero_out;
    wire [31:0] reg_data2_out;
    wire [63:0] addsum_out;
    wire [4:0] rd_out;
    integer fail;

    exe_mem_reg dut (
        .clk(clk),
        .flush(flush),
        .memwrite_in(memwrite_in),
        .memread_in(memread_in),
        .regwrite_in(regwrite_in),
        .memtoreg_in(memtoreg_in),
        .alu_result_in(alu_result_in),
        .zero(zero),
        .reg_data2_in(reg_data2_in),
        .addsum_in(addsum_in),
        .rd_in(rd_in),
        .memwrite_out(memwrite_out),
        .memread_out(memread_out),
        .regwrite_out(regwrite_out),
        .memtoreg_out(memtoreg_out),
        .alu_result_out(alu_result_out),
        .zero_out(zero_out),
        .reg_data2_out(reg_data2_out),
        .addsum_out(addsum_out),
        .rd_out(rd_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        fail = 0;

        flush = 1;
        memwrite_in = 1;
        memread_in = 1;
        regwrite_in = 1;
        memtoreg_in = 1;
        alu_result_in = 32'hABCD;
        zero = 1;
        reg_data2_in = 32'h1234;
        addsum_in = 64'h55;
        rd_in = 5'd9;

        @(posedge clk);
        if (memwrite_out !== 0 || rd_out !== 0) fail = fail + 1;

        flush = 0;
        @(posedge clk);
        if (memwrite_out !== 1 || alu_result_out !== 32'hABCD || rd_out !== 5'd9) fail = fail + 1;

        if (fail == 0) $display("tb_exe_mem_reg PASS");
        else $display("tb_exe_mem_reg FAIL count=%0d", fail);
        $finish;
    end
endmodule
