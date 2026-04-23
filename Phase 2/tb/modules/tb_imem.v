`timescale 1ns/1ps

module tb_imem;
    reg [31:0] addr;
    reg clk;
    wire [31:0] data;
    integer fail;

    imem dut (
        .addr(addr),
        .data(data),
        .clk(clk)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        fail = 0;

        dut.mem[0] = 8'hAA;
        dut.mem[1] = 8'hBB;
        dut.mem[2] = 8'hCC;
        dut.mem[3] = 8'hDD;

        addr = 32'd0;
        @(posedge clk);
        if (data !== 32'hDDCC_BBAA) fail = fail + 1;

        if (fail == 0) $display("tb_imem PASS");
        else $display("tb_imem FAIL count=%0d", fail);
        $finish;
    end
endmodule
