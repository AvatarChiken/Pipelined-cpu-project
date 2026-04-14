module reg_file (
    input  wire        clk,
    input  wire [4:0]  rs1,         
    input  wire [4:0]  rs2,         
    input  wire [4:0]  writereg,    
    input  wire [31:0] writedata,
    input  wire        regwrite,    
    output reg  [31:0] readdata1,
    output reg  [31:0] readdata2
);

    reg [31:0] registers [31:0];

    always @(posedge clk) begin
        if (regwrite && (writereg != 5'd0)) begin
            registers[writereg] <= writedata;
        end
    end

    always @(negedge clk) begin
        readdata1 <= (rs1 == 5'd0) ? 32'b0 : registers[rs1];
        readdata2 <= (rs2 == 5'd0) ? 32'b0 : registers[rs2];
    end

endmodule