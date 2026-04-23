module stage_if (
    input wire PCsrc,
    input wire [31:0] fromex_mem,
    input wire clk,
    input wire rst,
    input wire stall,
    output wire [31:0] PC,
    output wire [31:0] instruction
);
wire [31:0] adder_out;
wire [31:0] mux_out;
wire [31:0] pc_out;
wire [31:0] imem_out;

assign adder_out = pc_out + 32'd4;
assign mux_out = PCsrc ? fromex_mem : adder_out;

pc pc_inst(
    .PC_in(mux_out),
    .clk(clk),
    .reset(rst),
    .stall(stall),
    .PC_out(pc_out)
);

imem imem_inst(
    .addr(pc_out),
    .data(imem_out),
    .clk(clk)
);

assign PC = pc_out;
assign instruction = imem_out;

endmodule