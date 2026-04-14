module dmem (
    input wire [31:0] addr,
    output wire [31:0] readdata,
    input wire [31:0] writedata,
    input wire memwrite,
    input wire memread,
    input wire clk
);
reg [31:0] mem[0:255];
    always @(posedge clk && memwrite) begin
  
        mem[addr] <= writedata;

    end
    always @(negedge clk && memread) begin
        
        readdata <= mem[addr];
    end
else begin
    readdata <= 32'b0; // Default value when not reading
end
    
endmodule