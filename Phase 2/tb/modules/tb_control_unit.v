`timescale 1ns/1ps

module tb_control_unit;
    reg [6:0] opcode;
    wire [1:0] alusrc;
    wire [1:0] aluOP;
    wire regwrite;
    wire memtoreg;
    wire memwrite;
    wire memread;
    wire branch;
    wire pcsrc;
    integer fail;

    main_control dut (
        .opcode(opcode),
        .alusrc(alusrc),
        .aluOP(aluOP),
        .regwrite(regwrite),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .memread(memread),
        .branch(branch),
        .pcsrc(pcsrc)
    );

    initial begin
        fail = 0;

        opcode = 7'b0110011; #1;
        if (regwrite !== 1 || memread !== 0 || memwrite !== 0 || branch !== 0) fail = fail + 1;

        opcode = 7'b0000011; #1;
        if (regwrite !== 1 || memread !== 1 || memwrite !== 0 || memtoreg !== 1) fail = fail + 1;

        opcode = 7'b0100011; #1;
        if (regwrite !== 0 || memwrite !== 1 || memread !== 0) fail = fail + 1;

        opcode = 7'b1100011; #1;
        if (branch !== 1 || pcsrc !== 1) fail = fail + 1;

        if (fail == 0) $display("tb_control_unit PASS");
        else $display("tb_control_unit FAIL count=%0d", fail);
        $finish;
    end
endmodule
