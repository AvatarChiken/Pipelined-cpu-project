`timescale 1ns/1ps

module tb_imm_gen;
    reg [31:0] instruction;
    wire [63:0] immediate;
    integer fail;

    imm_gen dut (
        .instruction(instruction),
        .immediate(immediate)
    );

    initial begin
        fail = 0;

        // I-type: addi x1, x0, 5 => immediate = 5
        instruction = 32'h0050_0093; #1;
        if (immediate !== 64'd5) fail = fail + 1;

        // S-type: sw x2, 8(x0) => immediate = 8
        instruction = 32'h0020_2423; #1;
        if (immediate !== 64'd8) fail = fail + 1;

        if (fail == 0) $display("tb_imm_gen PASS");
        else $display("tb_imm_gen FAIL count=%0d", fail);
        $finish;
        end
    endmodule
