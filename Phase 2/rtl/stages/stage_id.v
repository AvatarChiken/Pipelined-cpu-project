module stage_id (
    input wire [63:0] PC_in,
    input wire [31:0] instruction_in,
    input wire regwrite_in,
    output wire [63:0] PC_out,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2,
    output wire [63:0] sign_imm,
    output wire [4:0] opcode,
    output wire [5:0] func7, 
    output wire [31:0] control_signals,
    input wire clk,
    input wire rst
);


    reg_file reg_file(.read_reg1(instruction_in[19:15]), .read_reg2(instruction_in[24:20]), .write_reg(instruction_in[11:7]), .write_data(read_data1), .regwrite(regwrite_in), .clk(clk), .rst(rst), .read_data1(read_data1), .read_data2(read_data2));
    imm_gen imm_gen(.instruction(instruction_in), .sign_imm(sign_imm));
    assign sign_imm = sign_imm_out;
    assign opcode = instruction_in[6:0];
    assign func7 = instruction_in[31:25];
    assign control_signals = instruction_in[31:0]; 
    assign PC_out = PC_in; // Pass the PC value to the next stage
endmodule