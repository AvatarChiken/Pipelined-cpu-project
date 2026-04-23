`timescale 1ns/1ps

module tb_stage_id;
    reg [31:0] PC_in;
    reg [31:0] instruction_in;
    reg wb_regwrite;
    reg [4:0] wb_rd;
    reg [31:0] wb_write_data;
    reg clk;

    wire [31:0] PC_out;
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [63:0] sign_imm;
    wire [6:0] opcode;
    wire [3:0] funct;
    wire [1:0] alusrc;
    wire [1:0] aluOP;
    wire regwrite;
    wire memtoreg;
    wire memwrite;
    wire memread;
    wire branch;
    wire [4:0] rd;
    integer fail;

    stage_id dut (
        .PC_in(PC_in),
        .instruction_in(instruction_in),
        .wb_regwrite(wb_regwrite),
        .wb_rd(wb_rd),
        .wb_write_data(wb_write_data),
        .PC_out(PC_out),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .sign_imm(sign_imm),
        .opcode(opcode),
        .funct(funct),
        .alusrc(alusrc),
        .aluOP(aluOP),
        .regwrite(regwrite),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .memread(memread),
        .branch(branch),
        .rd(rd),
        .clk(clk)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        fail = 0;
        PC_in = 32'd100;

        // Write x5 = 42 through WB path
        wb_regwrite = 1;
        wb_rd = 5'd5;
        wb_write_data = 32'd42;
        instruction_in = 32'h0000_0013;

        @(posedge clk);
        wb_regwrite = 0;

        // add x6, x5, x0
        instruction_in = 32'h0002_8333;
        @(negedge clk);

        if (PC_out !== 32'd100) fail = fail + 1;
        if (opcode !== 7'b0110011) fail = fail + 1;
        if (rd !== 5'd6) fail = fail + 1;
        if (read_data1 !== 32'd42) fail = fail + 1;

        if (fail == 0) $display("tb_stage_id PASS");
        else $display("tb_stage_id FAIL count=%0d", fail);
        $finish;
    end
endmodule
