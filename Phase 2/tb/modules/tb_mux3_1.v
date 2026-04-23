`timescale 1ns/1ps

module tb_mux3_1;
    reg A1;
    reg A2;
    reg A3;
    reg Select1;
    reg Select0;
    wire out;
    integer fail;

    mux3_1 dut (
        .out(out),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .Select1(Select1),
        .Select0(Select0)
    );

    initial begin
        fail = 0;
        A1 = 0; A2 = 1; A3 = 1;

        Select1 = 0; Select0 = 0; #1;
        if (out !== A1) fail = fail + 1;

        Select1 = 0; Select0 = 1; #1;
        if (out !== A2) fail = fail + 1;

        Select1 = 1; Select0 = 0; #1;
        if (out !== A3) fail = fail + 1;

        if (fail == 0) $display("tb_mux3_1 PASS");
        else $display("tb_mux3_1 FAIL count=%0d", fail);
        $finish;
    end
endmodule
