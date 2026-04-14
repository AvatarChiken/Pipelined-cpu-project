module stage_if (
    input wire PCsrc,
    input wire [63:0] fromex_mem,
    input wire clk,
    input wire rst,
    input wire stall,
    output wire [63:0] PC,
    output wire [31:0] instruction
);
wire adder_out, mux_out,pc_out,imem_out; 
mux2_1 mux(.out(mux_out), .A1(fromex_mem), .A2(adder_out), .Select(PCsrc));
adder adder(.A(PC), .B(64'd4), .sum(adder_out));
pc pc(.clk(clk), .rst(rst), .stall(stall), .in(mux_out), .out(pc_out));
imem imem(.addr(pc_out), .data(imem_out), .clk(clk));
endmodule 