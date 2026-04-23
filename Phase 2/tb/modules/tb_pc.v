`timescale 1ns/1ps

module tb_pc;
    reg [31:0] PC_in;
    reg clk;
    reg reset;
    reg stall;
    wire [31:0] PC_out;
    integer fail;

    pc dut (
        .PC_in(PC_in),
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .PC_out(PC_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        fail = 0;
        reset = 1;
        stall = 0;
        PC_in = 32'd12;

        @(posedge clk);
        if (PC_out !== 32'd0) fail = fail + 1;

        reset = 0;
        @(posedge clk);
        if (PC_out !== 32'd12) fail = fail + 1;

        stall = 1;
        PC_in = 32'd20;
        @(posedge clk);
        if (PC_out !== 32'd12) fail = fail + 1;

        if (fail == 0) $display("tb_pc PASS");
        else $display("tb_pc FAIL count=%0d", fail);
        $finish;
    end
endmodule
