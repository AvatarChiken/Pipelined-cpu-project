`timescale 1ns/1ps

module tb_mem_wb_reg;
    reg pc_src_in;
    reg memtoreg_in;
    reg [7:0] read_data_in;
    reg [31:0] addr_in;
    reg clk;
    reg flush;

    wire [31:0] pc_src_out;
    wire memtoreg_out;
    wire [7:0] read_data_out;
    wire [31:0] addr_out;
    integer fail;

    mem_wb_reg dut (
        .pc_src_in(pc_src_in),
        .memtoreg_in(memtoreg_in),
        .read_data_in(read_data_in),
        .addr_in(addr_in),
        .clk(clk),
        .flush(flush),
        .pc_src_out(pc_src_out),
        .memtoreg_out(memtoreg_out),
        .read_data_out(read_data_out),
        .addr_out(addr_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        fail = 0;

        flush = 1;
        pc_src_in = 1;
        memtoreg_in = 1;
        read_data_in = 8'hAA;
        addr_in = 32'h1234;

        @(posedge clk);
        if (pc_src_out !== 0 || memtoreg_out !== 0 || read_data_out !== 0) fail = fail + 1;

        flush = 0;
        @(posedge clk);
        if (pc_src_out !== 32'd1 || memtoreg_out !== 1 || read_data_out !== 8'hAA || addr_out !== 32'h1234) fail = fail + 1;

        if (fail == 0) $display("tb_mem_wb_reg PASS");
        else $display("tb_mem_wb_reg FAIL count=%0d", fail);
        $finish;
    end
endmodule
