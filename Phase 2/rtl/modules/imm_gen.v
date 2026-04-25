module imm_gen (
    input  wire [31:0] instruction,
    output reg  [63:0] immediate  
);
    wire [6:0] opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            // I-Type
            7'h14, 7'h68:
                immediate = { {52{instruction[31]}}, instruction[31:20] };

            // S-Type
            7'h24:
                immediate = { {52{instruction[31]}}, instruction[31:25], instruction[11:7] };

            // SB-Type
            7'h64:
                immediate = { {51{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0 };

            // UJ-Type 
            7'h70:
                immediate = { {43{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0 };

            default: 
                immediate = 64'd0;
        endcase
    end
endmodule