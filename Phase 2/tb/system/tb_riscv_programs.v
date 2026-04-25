`timescale 1ns/1ps

module tb_riscv_programs;
    reg clk;
    reg rst;
    integer i;
    integer fd;
    integer code;
    integer addr;
    integer max_cycles;
    reg [31:0] instr_word;
    reg [1023:0] program_file;

    riscv_core dut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        if (!$value$plusargs("PROGRAM=%s", program_file)) begin
            $display("Usage: vvp tb_riscv_programs.out +PROGRAM=<path-to-machine-code.txt>");
            $finish;
        end

        if (!$value$plusargs("CYCLES=%d", max_cycles)) begin
            max_cycles = 80;
        end

        clk = 0;
        rst = 1;

        // Initialize architectural state to known values.
        for (i = 0; i < 32; i = i + 1) begin
            dut.id_stage.reg_file_inst.registers[i] = 32'd0;
        end

        for (i = 0; i < 65536; i = i + 1) begin
            dut.if_stage.imem_inst.mem[i] = 8'h00;
        end

        for (i = 0; i < 8192; i = i + 1) begin
            dut.mem_stage_inst.dmem_inst.mem[i] = 8'h00;
        end

        // Load instruction words (hex per line) into little-endian byte-addressable IMEM.
        fd = $fopen(program_file, "r");
        if (fd == 0) begin
            $display("FAIL: could not open program file: %0s", program_file);
            $finish;
        end

        addr = 0;
        while (!$feof(fd)) begin
            code = $fscanf(fd, "%h\n", instr_word);
            if (code == 1) begin
                dut.if_stage.imem_inst.mem[addr]     = instr_word[7:0];
                dut.if_stage.imem_inst.mem[addr + 1] = instr_word[15:8];
                dut.if_stage.imem_inst.mem[addr + 2] = instr_word[23:16];
                dut.if_stage.imem_inst.mem[addr + 3] = instr_word[31:24];
                addr = addr + 4;
            end
        end
        $fclose(fd);

        #12;
        rst = 0;

        repeat (max_cycles) @(posedge clk);

        $display("RESULT program=%0s cycles=%0d pc=%h", program_file, max_cycles, dut.if_stage.pc_inst.PC_out);
        $display("REG x1=%0d x2=%0d x3=%0d x4=%0d x5=%0d x6=%0d x7=%0d x8=%0d x9=%0d x10=%0d", 
                 dut.id_stage.reg_file_inst.registers[1],
                 dut.id_stage.reg_file_inst.registers[2],
                 dut.id_stage.reg_file_inst.registers[3],
                 dut.id_stage.reg_file_inst.registers[4],
                 dut.id_stage.reg_file_inst.registers[5],
                 dut.id_stage.reg_file_inst.registers[6],
                 dut.id_stage.reg_file_inst.registers[7],
                 dut.id_stage.reg_file_inst.registers[8],
                 dut.id_stage.reg_file_inst.registers[9],
                 dut.id_stage.reg_file_inst.registers[10]);

        $display("DMEM[0]=%0d DMEM[4]=%0d", 
                 {dut.mem_stage_inst.dmem_inst.mem[3], dut.mem_stage_inst.dmem_inst.mem[2], dut.mem_stage_inst.dmem_inst.mem[1], dut.mem_stage_inst.dmem_inst.mem[0]},
                 {dut.mem_stage_inst.dmem_inst.mem[7], dut.mem_stage_inst.dmem_inst.mem[6], dut.mem_stage_inst.dmem_inst.mem[5], dut.mem_stage_inst.dmem_inst.mem[4]});

        if (^dut.if_stage.pc_inst.PC_out === 1'bx) begin
            $display("FAIL: PC has unknown bits");
        end else begin
            $display("PASS: simulation completed without unknown PC");
        end

        $finish;
    end
endmodule
