`timescale 1ns/1ps

module tb_riscv_core;
	reg clk;
	reg rst;
	integer fail;

	riscv_core dut (
		.clk(clk),
		.rst(rst)
	);

	always #5 clk = ~clk;

	initial begin
		clk = 0;
		rst = 1;
		fail = 0;

		// add x3, x1, x2
		dut.if_stage.imem_inst.mem[0] = 8'hB3;
		dut.if_stage.imem_inst.mem[1] = 8'h81;
		dut.if_stage.imem_inst.mem[2] = 8'h20;
		dut.if_stage.imem_inst.mem[3] = 8'h00;

		dut.id_stage.reg_file_inst.registers[1] = 32'd5;
		dut.id_stage.reg_file_inst.registers[2] = 32'd7;

		#12;
		rst = 0;

		repeat (8) @(posedge clk);

		if (dut.id_stage.reg_file_inst.registers[3] !== 32'd12) begin
			$display("tb_riscv_core FAIL: x3 expected 12 got %0d", dut.id_stage.reg_file_inst.registers[3]);
			fail = fail + 1;
		end

		if (dut.if_stage.pc_inst.PC_out === 32'bx) begin
			$display("tb_riscv_core FAIL: PC became unknown");
			fail = fail + 1;
		end

		if (fail == 0) $display("tb_riscv_core PASS");
		else $display("tb_riscv_core FAIL count=%0d", fail);

		$finish;
	end
endmodule
