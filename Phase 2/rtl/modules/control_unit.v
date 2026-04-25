module main_control (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    output reg [1:0] alusrc,
    output reg [2:0] aluOP,
    output reg regwrite,
    output reg memtoreg,
    output reg memwrite,
    output reg memread,
    output reg branch

);
always @(*) begin
    case (opcode)
        7'h34: begin // R-type
            alusrc = 2'b00;
            aluOP = 3'b010;
            regwrite = 1'b1;
            memtoreg = 1'b0;
            memwrite = 1'b0;
            memread = 1'b0;
            branch = 1'b0;
        end

        7'h14: begin // I-type: addiw/andi/ori/lw
            alusrc = 2'b01;
            if (funct3 == 3'h3) begin // lw
                aluOP = 3'b000;
                regwrite = 1'b1;
                memtoreg = 1'b1;
                memwrite = 1'b0;
                memread = 1'b1;
            end else begin
                aluOP = 3'b011;
                regwrite = 1'b1;
                memtoreg = 1'b0;
                memwrite = 1'b0;
                memread = 1'b0;
            end
            branch = 1'b0;
        end

        7'h24: begin // S-type: sw
            alusrc = 2'b01;
            aluOP = 3'b000;
            regwrite = 1'b0;
            memtoreg = 1'bx;
            memwrite = 1'b1;
            memread = 1'b0;
            branch = 1'b0;
        end

        7'h64: begin // SB-type: bge/bne
            alusrc = 2'b00;
            aluOP = 3'b001;
            regwrite = 1'b0;
            memtoreg = 1'bx;
            memwrite = 1'b0;
            memread = 1'b0;
            branch = 1'b1;
        end

        7'h70: begin // UJ-type: jal
            alusrc = 2'b10;
            aluOP = 3'b100;
            regwrite = 1'b1;
            memtoreg = 1'b0;
            memwrite = 1'b0;
            memread = 1'b0;
            branch = 1'b1;
        end

        7'h68: begin // I-type: jalr
            alusrc = 2'b11;
            aluOP = 3'b100;
            regwrite = 1'b1;
            memtoreg = 1'b0;
            memwrite = 1'b0;
            memread = 1'b0;
            branch = 1'b1;
        end

        default: begin // Default case for unsupported opcodes
            alusrc = 2'b00;
            aluOP = 3'b000;
            regwrite = 1'b0;
            memtoreg = 1'b0;
            memwrite = 1'b0;
            memread = 1'b0;
            branch = 1'b0;
        end
    endcase
end
    
endmodule