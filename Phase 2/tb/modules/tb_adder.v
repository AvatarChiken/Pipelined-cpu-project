`timescale 1ns/1ps

module tb_adder;
    reg A;
    reg B;
    wire sum;
    wire carry;
    integer fail;

    adder dut (
        .A(A),
        .B(B),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        fail = 0;

        A = 0; B = 0; #1;
        if (sum !== 0 || carry !== 0) fail = fail + 1;

        A = 0; B = 1; #1;
        if (sum !== 1 || carry !== 0) fail = fail + 1;

        A = 1; B = 0; #1;
        if (sum !== 1 || carry !== 0) fail = fail + 1;

        A = 1; B = 1; #1;
        if (sum !== 0 || carry !== 1) fail = fail + 1;

        if (fail == 0) $display("tb_adder PASS");
        else $display("tb_adder FAIL count=%0d", fail);
        $finish;
    end
endmodule
