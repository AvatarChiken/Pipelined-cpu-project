module dmem (
    input wire [31:0] addr,
    input wire [31:0] writedata,
    input wire memwrite,
    input wire memread,
    input wire clk,
    output reg [31:0] readdata
);
    // Byte-addressable data memory: 8KB of bytes
    reg [7:0] mem[0:8191]; // 8KB memory (byte-addressable)

    // Synchronous read/write. Writes store 4 bytes (little-endian).
    always @(posedge clk) begin
        if (memwrite) begin
            mem[addr[15:0]]               <= writedata[7:0];
            mem[addr[15:0] + 16'd1]      <= writedata[15:8];
            mem[addr[15:0] + 16'd2]      <= writedata[23:16];
            mem[addr[15:0] + 16'd3]      <= writedata[31:24];
        end

        if (memread) begin
            readdata <= { mem[addr[15:0] + 16'd3], mem[addr[15:0] + 16'd2], mem[addr[15:0] + 16'd1], mem[addr[15:0]] };
        end else begin
            readdata <= 32'b0;
        end
    end

endmodule