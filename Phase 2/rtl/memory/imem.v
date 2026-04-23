module imem (
    input wire [31:0] addr,
    output reg [31:0] data,
    input wire clk
);
    // Byte-addressable instruction memory: 64KB of bytes
    reg [7:0] mem[0:65535]; // 64KB memory (byte-addressable)

    // Assemble 32-bit little-endian instruction from four consecutive bytes
    always @(posedge clk) begin
        data <= { mem[addr[15:0] + 16'd3], mem[addr[15:0] + 16'd2], mem[addr[15:0] + 16'd1], mem[addr[15:0]] };
    end

endmodule