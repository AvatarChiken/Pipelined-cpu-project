module alu (
    input wire [31:0] operand_a,
    input wire [31:0] operand_b,
    input wire [2:0] alu_control,
    output wire zero,
    output wire [31:0] result
);
    reg [31:0] alu_result;

    always @(*) begin
        case (alu_control) 
            3'b000: alu_result = operand_a & operand_b; // AND
            3'b001: alu_result = operand_a | operand_b; // OR
            3'b010: alu_result = operand_a + operand_b; // ADD
            3'b110: alu_result = operand_a - operand_b; // SUB
            default: alu_result = 32'd0;
        endcase
    end

    assign result = alu_result;
    assign zero = (alu_result == 32'd0) ? 1'b1 : 1'b0;

endmodule