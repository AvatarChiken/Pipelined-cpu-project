module imem (
    input wire [31:0] addr,
    output wire [31:0] data,
    input wire clk
);
 reg [31:0] mem[0:65535]; // 64KB memory
 always @(posedge clk) begin
  
        data <= mem[addr];

end

    
endmodule