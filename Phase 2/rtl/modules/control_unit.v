module main_control (
    input wire [6:0] opcode,
    output reg [1:0] alusrc,
    output reg [1:0] aluOP,
    output reg regwrite,
    output reg memtoreg,
    output reg memwrite,
    output reg memread,
    output reg branch,
    output reg pcsrc

);
always @(*) begin
    case (opcode)
        7'b0110011: begin // R-type
            alusrc = 2'b00;
            aluOP = 2'b10;
            regwrite = 1;
            memtoreg = 0;
            memwrite = 0;
            memread = 0;
            branch = 0;
            pcsrc = 0;
        end
        7'b0000011: begin // ld / lw
            alusrc = 2'b01;
            aluOP = 2'b00;
            regwrite = 1;
            memtoreg = 1;
            memwrite = 0;
            memread = 1;
            branch = 0;
            pcsrc = 0;
        end
        7'b0100011: begin // sd / sw
            alusrc = 2'b01;
            aluOP = 2'b00;
            regwrite = 0;
            memtoreg = 1'bx; // Don't care
            memwrite = 1;
            memread = 0;
            branch = 0;
            pcsrc = 0;
        end
        7'b1100011: begin // beq
            alusrc = 2'b00;
            aluOP = 2'b01;
            regwrite = 0;
            memtoreg = 1'bx; // Don't care
            memwrite = 0;
            memread = 0;
            branch = 1;
            pcsrc = 1;
        end
        default: begin // Default case for unsupported opcodes
            alusrc = 2'bx; // Don't care
            aluOP = 2'bx; // Don't care
            regwrite = 0;
            memtoreg = 1'bx; // Don't care
            memwrite = 0;
            memread = 0;
            branch = 0;
            pcsrc = 0;
        end
    endcase
end
    
endmodule