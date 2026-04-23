`timescale 1ns/1ps

module tb_alu;
	reg [31:0] operand_a;
	reg [31:0] operand_b;
	reg [2:0] alu_control;
	wire zero;
	wire [31:0] result;
	integer fail;

	alu dut (
		.operand_a(operand_a),
		.operand_b(operand_b),
		.alu_control(alu_control),
		.zero(zero),
		.result(result)
	);

	initial begin
		fail = 0;

		operand_a = 32'd10; operand_b = 32'd5; alu_control = 3'b010; #1;
		if (result !== 32'd15) begin
			$display("tb_alu FAIL: ADD expected 15 got %0d", result);
			fail = fail + 1;
		end

		operand_a = 32'hF0F0_F0F0; operand_b = 32'h0F0F_0F0F; alu_control = 3'b000; #1;
		if (result !== 32'h0000_0000 || zero !== 1'b1) begin
			$display("tb_alu FAIL: AND/zero mismatch result=%h zero=%b", result, zero);
			fail = fail + 1;
		end

		operand_a = 32'd9; operand_b = 32'd9; alu_control = 3'b110; #1;
		if (result !== 32'd0 || zero !== 1'b1) begin
			$display("tb_alu FAIL: SUB expected 0 got %0d", result);
			fail = fail + 1;
		end

		if (fail == 0) $display("tb_alu PASS");
		else $display("tb_alu FAIL count=%0d", fail);
		$finish;
	end
endmodule
