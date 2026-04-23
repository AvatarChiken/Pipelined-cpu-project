`timescale 1ns/1ps

module tb_reg_file;
	reg clk;
	reg [4:0] rs1;
	reg [4:0] rs2;
	reg [4:0] writereg;
	reg [31:0] writedata;
	reg regwrite;
	wire [31:0] readdata1;
	wire [31:0] readdata2;
	integer fail;

	reg_file dut (
		.clk(clk),
		.rs1(rs1),
		.rs2(rs2),
		.writereg(writereg),
		.writedata(writedata),
		.regwrite(regwrite),
		.readdata1(readdata1),
		.readdata2(readdata2)
	);

	always #5 clk = ~clk;

	initial begin
		clk = 0;
		fail = 0;
		rs1 = 0;
		rs2 = 0;
		writereg = 0;
		writedata = 0;
		regwrite = 0;

		@(posedge clk);
		writereg = 5'd3;
		writedata = 32'h1234_5678;
		regwrite = 1'b1;

		@(posedge clk);
		regwrite = 1'b0;
		rs1 = 5'd3;
		rs2 = 5'd0;

		@(negedge clk);
		if (readdata1 !== 32'h1234_5678) begin
			$display("tb_reg_file FAIL: r3 expected 0x12345678 got %h", readdata1);
			fail = fail + 1;
		end
		if (readdata2 !== 32'd0) begin
			$display("tb_reg_file FAIL: r0 expected 0 got %h", readdata2);
			fail = fail + 1;
		end

		@(posedge clk);
		writereg = 5'd0;
		writedata = 32'hFFFF_FFFF;
		regwrite = 1'b1;

		@(posedge clk);
		regwrite = 1'b0;
		rs1 = 5'd0;

		@(negedge clk);
		if (readdata1 !== 32'd0) begin
			$display("tb_reg_file FAIL: x0 should stay zero, got %h", readdata1);
			fail = fail + 1;
		end

		if (fail == 0) $display("tb_reg_file PASS");
		else $display("tb_reg_file FAIL count=%0d", fail);
		$finish;
	end
endmodule
