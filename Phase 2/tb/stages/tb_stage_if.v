`timescale 1ns/1ps

module tb_stage_if;
	reg PCsrc;
	reg [31:0] fromex_mem;
	reg clk;
	reg rst;
	reg stall;
	wire [31:0] PC;
	wire [31:0] instruction;
	integer fail;

	stage_if dut (
		.PCsrc(PCsrc),
		.fromex_mem(fromex_mem),
		.clk(clk),
		.rst(rst),
		.stall(stall),
		.PC(PC),
		.instruction(instruction)
	);

	always #5 clk = ~clk;

	initial begin
		clk = 0;
		fail = 0;
		PCsrc = 0;
		fromex_mem = 32'd0;
		stall = 0;
		rst = 1;

		// Program words at address 0 and 4 (little endian bytes).
		dut.imem_inst.mem[0] = 8'h13;
		dut.imem_inst.mem[1] = 8'h00;
		dut.imem_inst.mem[2] = 8'h00;
		dut.imem_inst.mem[3] = 8'h00;

		dut.imem_inst.mem[4] = 8'h93;
		dut.imem_inst.mem[5] = 8'h00;
		dut.imem_inst.mem[6] = 8'h10;
		dut.imem_inst.mem[7] = 8'h00;

		@(posedge clk);
		rst = 0;

		@(posedge clk);
		if (PC !== 32'd4) begin
			$display("tb_stage_if FAIL: expected PC=4 got %0d", PC);
			fail = fail + 1;
		end

		@(posedge clk);
		if (instruction !== 32'h0010_0093) begin
			$display("tb_stage_if FAIL: expected instruction 0x00100093 got %h", instruction);
			fail = fail + 1;
		end

		PCsrc = 1;
		fromex_mem = 32'd16;
		@(posedge clk);
		PCsrc = 0;

		@(posedge clk);
		if (PC !== 32'd20) begin
			$display("tb_stage_if FAIL: branch path expected PC=20 got %0d", PC);
			fail = fail + 1;
		end

		if (fail == 0) $display("tb_stage_if PASS");
		else $display("tb_stage_if FAIL count=%0d", fail);
		$finish;
	end
endmodule
