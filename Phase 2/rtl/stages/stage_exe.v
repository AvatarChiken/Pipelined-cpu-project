module exe_stage (
    input wire [2:0] aluOP,
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
reg branch_taken_r;

assign addsum = {32'b0, ((alusrc == 2'b11) ? (read_data1 + sign_imm[31:0]) : (PC_in + sign_imm[31:0]))};

always @(*) begin
    alu_input2 = (alusrc == 2'b01) ? sign_imm[31:0] : read_data2;
    branch_taken_r = 1'b0;

    case (aluOP)
        3'b000: begin
            alu_result_r = read_data1 + alu_input2;
        end

        3'b001: begin // Branch compare
            alu_result_r = read_data1 - read_data2;
            case (funct[2:0])
                3'b010: branch_taken_r = (read_data1 != read_data2); // bne
                3'b110: branch_taken_r = ($signed(read_data1) >= $signed(read_data2)); // bge
                default: branch_taken_r = 1'b0;
            endcase
        end

        3'b010: begin // R-type
            case (funct)
                4'b0001: alu_result_r = read_data1 + read_data2; // addw
                4'b0000: alu_result_r = read_data1 & read_data2; // and
                4'b0101: alu_result_r = read_data1 ^ read_data2; // xor
                4'b0111: alu_result_r = read_data1 | read_data2; // or
                4'b0100: alu_result_r = ($unsigned(read_data1) < $unsigned(read_data2)) ? 32'd1 : 32'd0; // sltu
                4'b0110: alu_result_r = read_data1 >> read_data2[4:0]; // srl
                4'b1110: alu_result_r = $signed(read_data1) >>> read_data2[4:0]; // sra
                default: alu_result_r = 32'b0;
            endcase
        end

        3'b011: begin // I-type arithmetic/logical
            case (funct[2:0])
                3'b001: alu_result_r = read_data1 + sign_imm[31:0]; // addiw
                3'b000: alu_result_r = read_data1 & sign_imm[31:0]; // andi
                3'b111: alu_result_r = read_data1 | sign_imm[31:0]; // ori
                default: alu_result_r = read_data1 + sign_imm[31:0];
            endcase
        end

        3'b100: begin // jal/jalr
            alu_result_r = PC_in + 32'd4;
            branch_taken_r = 1'b1;
        end

        default: begin
            alu_result_r = 32'b0;
        end
    endcase
end

assign alu_result = alu_result_r;
assign zero = branch ? branch_taken_r : (alu_result_r == 32'b0);
assign reg_data2_out = read_data2;
assign PC_out = PC_in;
assign regwrite_out = regwrite;
assign memtoreg_out = memtoreg;
assign memwrite_out = memwrite;
assign memread_out = memread;
assign branch_out = branch;
assign rd_out = rd;

endmodule