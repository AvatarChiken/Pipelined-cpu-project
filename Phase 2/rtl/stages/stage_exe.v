module exe_stage (
    input wire [1:0] aluOP,
    input wire [1:0] alusrc,
    input wire regwrite,
    input wire memtoreg,
    input wire memwrite,
    input wire memread,
    input wire branch,
    input wire [31:0] PC_in,
    input wire [31:0] read_data1,
    input wire [31:0] read_data2,
    input wire [63:0] sign_imm,
    input wire [3:0] funct,
    input wire [4:0] rd,
    output wire [31:0] PC_out,
    output wire [31:0] alu_result,
    output wire regwrite_out,
    output wire memtoreg_out,
    output wire memwrite_out,
    output wire memread_out,
    output wire branch_out,
    output wire [4:0] rd_out,
    output wire zero,
    output wire [31:0] reg_data2_out,
    output wire [63:0] addsum

);
reg [31:0] alu_result_r;
reg [31:0] alu_input2;

assign addsum = {32'b0, (PC_in + sign_imm[31:0])};

always @(*) begin
    alu_input2 = (alusrc == 2'b01) ? sign_imm[31:0] : read_data2;

    case (aluOP)
        2'b00: alu_result_r = read_data1 + alu_input2;
        2'b01: alu_result_r = read_data1 - alu_input2;
        2'b10: begin
            case (funct)
                4'b0000: alu_result_r = read_data1 + alu_input2;
                4'b1000: alu_result_r = read_data1 - alu_input2;
                4'b0111: alu_result_r = read_data1 & alu_input2;
                4'b0110: alu_result_r = read_data1 | alu_input2;
                default: alu_result_r = 32'b0;
            endcase
        end
        default: alu_result_r = 32'b0;
    endcase
end

assign alu_result = alu_result_r;
assign zero = (alu_result_r == 32'b0);
assign reg_data2_out = read_data2;
assign PC_out = PC_in;
assign regwrite_out = regwrite;
assign memtoreg_out = memtoreg;
assign memwrite_out = memwrite;
assign memread_out = memread;
assign branch_out = branch;
assign rd_out = rd;

endmodule