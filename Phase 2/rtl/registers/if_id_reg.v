module ifidreg (
    input wire [31:0] PC_in,
    input wire [31:0] instruction_in,
    input wire clk,
    input wire flush,
    output reg [31:0] PC_out,
    output reg [31:0] instruction_out
);
    always @(posedge clk or posedge flush) begin
        if (flush) begin
            PC_out <= 32'd0;
            instruction_out <= 32'd0;
        end else begin
            PC_out <= PC_in;
            instruction_out <= instruction_in;
        end
    end
endmodule