`timescale 1ns/1ps

module tb_mux2_1;
    reg A1;
    reg A2;
    reg Select;
    wire out;
    integer fail;

    mux2_1 dut (
        .out(out),
        .A1(A1),
        .A2(A2),
        .Select(Select)
    );

    initial begin
        fail = 0;

        A1 = 0; A2 = 1; Select = 0; #1;
        if (out !== 0) fail = fail + 1;

        A1 = 0; A2 = 1; Select = 1; #1;
        if (out !== 1) fail = fail + 1;

        if (fail == 0) $display("tb_mux2_1 PASS");
        else $display("tb_mux2_1 FAIL count=%0d", fail);
        $finish;
    end
endmodule
