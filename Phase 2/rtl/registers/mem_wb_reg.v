module mem_wb_reg(
    input wire pc_src_in,
    input wire memtoreg_in,
    input wire [7:0] read_data_in,
    input wire [31:0] addr_in,
    input wire clk,
    input wire flush,
    output reg [31:0] pc_src_out,
    output reg memtoreg_out,
    output reg [7:0] read_data_out,
    output reg [31:0] addr_out
);
    always @(posedge clk or posedge flush) begin
        if (flush) begin
            pc_src_out <= 32'd0;
            memtoreg_out <= 1'b0;
            read_data_out <= 8'd0;
            addr_out <= 32'd0;
        end else begin
            pc_src_out <= pc_src_in;
            memtoreg_out <= memtoreg_in;
            read_data_out <= read_data_in;
            addr_out <= addr_in;
        end
    end
endmodule

    
