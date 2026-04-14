module imm_gen (
    input  wire [31:0] instruction,
    output reg  [63:0] immediate  
);
    wire [6:0] opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            // I-Type
            7'b0000011, 7'b0010011, 7'b1100111: 
                immediate = { {52{instruction[31]}}, instruction[31:20] };

            // S-Type
            7'b0100011: 
                immediate = { {52{instruction[31]}}, instruction[31:25], instruction[11:7] };

            // SB-Type
            7'b1100011: 
                immediate = { {52{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8]};

            // UJ-Type 
            7'b1101111:
                immediate = { {44{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21] };

            default: 
                immediate = 64'd0;
        endcase
    end
endmodule