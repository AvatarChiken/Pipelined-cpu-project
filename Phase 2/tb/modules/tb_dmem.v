`timescale 1ns/1ps

module tb_dmem;
    reg [31:0] addr;
    reg [31:0] writedata;
    reg memwrite;
    reg memread;
    reg clk;
    wire [31:0] readdata;
    integer fail;

    dmem dut (
        .addr(addr),
        .writedata(writedata),
        .memwrite(memwrite),
        .memread(memread),
        .clk(clk),
        .readdata(readdata)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        fail = 0;
        addr = 32'd16;
        writedata = 32'hA1B2_C3D4;
        memwrite = 1;
        memread = 0;

        @(posedge clk);
        memwrite = 0;
        memread = 1;

        @(posedge clk);
        if (readdata !== 32'hA1B2_C3D4) fail = fail + 1;

        if (fail == 0) $display("tb_dmem PASS");
        else $display("tb_dmem FAIL count=%0d", fail);
        $finish;
    end
endmodule
