module stage_wb (
    input wire memtoreg,
    input wire regwrite_in,
    input wire [4:0] rd_in,
    input wire [31:0] read_data_in,
    input wire [31:0] alu_result_in,
    output wire regwrite_out,
    output wire [4:0] rd_out,
    output wire [31:0] write_data
);
assign write_data = memtoreg ? read_data_in : alu_result_in;
assign rd_out = rd_in;
assign regwrite_out = regwrite_in;
    
endmodule