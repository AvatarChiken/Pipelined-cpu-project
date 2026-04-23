module ID_EXE_reg (
    input wire [31:0] PC_in,
    input wire [2:0] aluSrc_in,
    input wire [2:0] aluOp_in,
    input wire regWrite_in,
    input wire memRead_in,
    input wire memWrite_in,
    input wire memToReg_in,
    input wire branch_in,
    input wire [31:0] readData1_in,
    input wire [31:0] readData2_in,
    input wire [63:0] immediate_in,
    input wire [4:0] opcode_in,
    input wire [5:0] regwriteaddr_in,
    input wire clk,
    input wire flush,
    output reg [31:0] PC_out,
    output reg [2:0] aluSrc_out,
    output reg [2:0] aluOp_out,
    output reg regWrite_out,
    output reg memRead_out,
    output reg memWrite_out,
    output reg memToReg_out,
    output reg branch_out,
    output reg [31:0] readData1_out,
    output reg [31:0] readData2_out,
    output reg [63:0] immediate_out,
    output reg [4:0] opcode_out,
    output reg [5:0] regwriteaddr_out
);
    always @(posedge clk or posedge flush) begin
        if (flush) begin
            PC_out <= 32'd0;
            aluSrc_out <= 3'd0;
            aluOp_out <= 3'd0;
            regWrite_out <= 1'd0;
            memRead_out <= 1'd0;
            memWrite_out <= 1'd0;
            memToReg_out <= 1'd0;
            branch_out <= 1'd0;
            readData1_out <= 32'd0;
            readData2_out <= 32'd0;
            immediate_out <= 64'd0;
            opcode_out <= 5'd0;
            regwriteaddr_out <= 6'd0;
        end else begin
            PC_out <= PC_in;
            aluSrc_out <= aluSrc_in;
            aluOp_out <= aluOp_in;
            regWrite_out <= regWrite_in;
            memRead_out <= memRead_in;
            memWrite_out <= memWrite_in;
            memToReg_out <= memToReg_in;
            branch_out <= branch_in;
            readData1_out <= readData1_in;
            readData2_out <= readData2_in;
            immediate_out <= immediate_in;
            opcode_out <= opcode_in;
            regwriteaddr_out <= regwriteaddr_in;
        end
    end 

    
endmodule