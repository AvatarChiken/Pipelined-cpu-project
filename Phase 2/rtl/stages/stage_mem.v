module mem_stage (
    input wire regwrite,
    input wire memtoreg,
    input wire memwrite,
    input wire memread,
    input wire branch,
    input wire [31:0] PC_in,
    input wire zero,
    input wire [63:0] addsum,
    input wire [4:0] rd,
    input wire [31:0] alu_result,
    input wire [31:0] reg_data2,
    input wire clk,
    output wire [4:0] rd_out,
    output wire [31:0] read_data,
    output wire [31:0] PC_out,
    output wire regwrite_out,
    output wire memtoreg_out,
    output wire pcsrc_out,
    output wire [31:0] branch_target_out,
    output wire [31:0] alu_result_out
);
dmem dmem_inst (
    .addr(alu_result),
    .writedata(reg_data2),
    .memwrite(memwrite),
    .memread(memread),
    .clk(clk),
    .readdata(read_data)
);

assign PC_out = PC_in;
assign rd_out = rd;
assign regwrite_out = regwrite;
assign memtoreg_out = memtoreg;
assign pcsrc_out = branch & zero;
assign branch_target_out = addsum[31:0];
assign alu_result_out = alu_result;
    
endmodule