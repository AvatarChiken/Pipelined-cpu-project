module ALUcontrol (
    input wire [1:0] ALUOp,
    input wire [5:0] funct,
    output reg [3:0] ALUControl
);
    
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0010; // LW/SW (ADD)
            2'b01: ALUControl = 4'b0110; // BEQ (SUB)
            2'b10: begin // R-type
                case (funct)
                    6'b100000: ALUControl = 4'b0010; // ADD
                    6'b100010: ALUControl = 4'b0110; // SUB
                    6'b100100: ALUControl = 4'b0000; // AND
                    6'b100101: ALUControl = 4'b0001; // OR
                    default: ALUControl = 4'b1111; // Invalid funct
                endcase
            end
            default: ALUControl = 4'b1111; // Invalid ALUOp
        endcase
    end

    
endmodule