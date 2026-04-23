`timescale 1ns/1ps

module tb_Shift;
    reg [63:0] in;
    wire [63:0] out;
    integer fail;

    Shift dut (
        .in(in),
        .out(out)
    );

    initial begin
        fail = 0;
        in = 64'd3; #1;
        if (out !== 64'd6) fail = fail + 1;

        in = 64'h8000_0000_0000_0001; #1;
        if (out !== 64'h0000_0000_0000_0002) fail = fail + 1;

        if (fail == 0) $display("tb_Shift PASS");
        else $display("tb_Shift FAIL count=%0d", fail);
        $finish;
    end
endmodule
