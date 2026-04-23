module exe_mem_reg (
    input wire clk,
    input wire flush,
    input wire memwrite_in,
    input wire memread_in,
    input wire regwrite_in,
    input wire memtoreg_in,
    input wire [31:0] alu_result_in,
    input wire zero,
    input wire [31:0] reg_data2_in,
    input wire [63:0] addsum_in,
    input wire [4:0] rd_in,
    output reg memwrite_out,
    output reg memread_out,
    output reg regwrite_out,
    output reg memtoreg_out,
    output reg [31:0] alu_result_out,
    output reg zero_out,
    output reg [31:0] reg_data2_out,
    output reg [63:0] addsum_out,
    output reg [4:0] rd_out
);
    always @(posedge clk) begin
        if (flush) begin
            memwrite_out <= 0;
            memread_out <= 0;
            regwrite_out <= 0;
            memtoreg_out <= 0;
            alu_result_out <= 0;
            zero_out <= 0;
            reg_data2_out <= 0;
            addsum_out <= 0;
            rd_out <= 0;
        end else begin
            memwrite_out <= memwrite_in;
            memread_out <= memread_in;
            regwrite_out <= regwrite_in;
            memtoreg_out <= memtoreg_in;
            alu_result_out <= alu_result_in;
            zero_out <= zero;
            reg_data2_out <= reg_data2_in;
            addsum_out <= addsum_in;
            rd_out <= rd_in;
        end
    end
    
    
endmodule