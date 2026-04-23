`timescale 1ns/1ps

module tb_stage_wb;
    reg memtoreg;
    reg regwrite_in;
    reg [4:0] rd_in;
    reg [31:0] read_data_in;
    reg [31:0] alu_result_in;

    wire regwrite_out;
    wire [4:0] rd_out;
    wire [31:0] write_data;
    integer fail;

    stage_wb dut (
        .memtoreg(memtoreg),
        .regwrite_in(regwrite_in),
        .rd_in(rd_in),
        .read_data_in(read_data_in),
        .alu_result_in(alu_result_in),
        .regwrite_out(regwrite_out),
        .rd_out(rd_out),
        .write_data(write_data)
    );

    initial begin
        fail = 0;

        memtoreg = 0;
        regwrite_in = 1;
        rd_in = 5'd12;
        read_data_in = 32'hAAAA_BBBB;
        alu_result_in = 32'h1111_2222;
        #1;

        if (write_data !== 32'h1111_2222 || regwrite_out !== 1 || rd_out !== 5'd12) fail = fail + 1;

        memtoreg = 1;
        #1;
        if (write_data !== 32'hAAAA_BBBB) fail = fail + 1;

        if (fail == 0) $display("tb_stage_wb PASS");
        else $display("tb_stage_wb FAIL count=%0d", fail);
        $finish;
    end
endmodule
