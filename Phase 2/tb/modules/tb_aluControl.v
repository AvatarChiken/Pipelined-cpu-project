`timescale 1ns/1ps

module tb_aluControl;
    reg [1:0] ALUOp;
    reg [3:0] funct;
    wire [3:0] ALUControl;
    integer fail;

    ALUcontrol dut (
        .ALUOp(ALUOp),
        .funct(funct),
        .ALUControl(ALUControl)
    );

    initial begin
        fail = 0;

        ALUOp = 2'b00; funct = 4'b0000; #1;
        if (ALUControl !== 4'b0010) fail = fail + 1;

        ALUOp = 2'b01; funct = 4'b0000; #1;
        if (ALUControl !== 4'b0110) fail = fail + 1;

        ALUOp = 2'b10; funct = 4'b0000; #1;
        if (ALUControl !== 4'b0010) fail = fail + 1;

        ALUOp = 2'b10; funct = 4'b0001; #1;
        if (ALUControl !== 4'b0110) fail = fail + 1;

        if (fail == 0) $display("tb_aluControl PASS");
        else $display("tb_aluControl FAIL count=%0d", fail);
        $finish;
    end
endmodule
