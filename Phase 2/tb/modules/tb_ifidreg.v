`timescale 1ns/1ps

module tb_ifidreg;
    reg [31:0] PC_in;
    reg [31:0] instruction_in;
    reg clk;
    reg flush;
    wire [31:0] PC_out;
    wire [31:0] instruction_out;
    integer fail;

    ifidreg dut (
        .PC_in(PC_in),
        .instruction_in(instruction_in),
        .clk(clk),
        .flush(flush),
        .PC_out(PC_out),
        .instruction_out(instruction_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        fail = 0;
        flush = 1;
        PC_in = 32'd100;
        instruction_in = 32'h1234_5678;

        @(posedge clk);
        if (PC_out !== 32'd0 || instruction_out !== 32'd0) fail = fail + 1;

        flush = 0;
        @(posedge clk);
        if (PC_out !== 32'd100 || instruction_out !== 32'h1234_5678) fail = fail + 1;

        if (fail == 0) $display("tb_ifidreg PASS");
        else $display("tb_ifidreg FAIL count=%0d", fail);
        $finish;
    end
endmodule
