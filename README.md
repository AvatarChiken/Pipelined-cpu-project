# Pipelined CPU Project (RISC-V)

This repository is organized as a multi-phase project:

1. Phase 1 builds a custom assembler in C++.
2. Phase 2 implements and verifies a hardware pipeline in Verilog.

The intent is an end-to-end flow: write RISC-V assembly, assemble it into machine code, then execute that code on the pipelined core.

## High-Level Phase Map

- Phase 1: Software toolchain (assembler)
- Phase 2: Hardware datapath/control (RTL + testbenches)
- Shared test assets: assembly programs and expected machine code outputs

---

## Phase 1: Assembler (C++)

### Goal

Convert RISC-V assembly source files into 32-bit machine code words that can be loaded into instruction memory.

### Structure

- `Phase 1/assembler.cpp`
	- Main program flow.
	- Handles file input, pass execution, and final output generation.
- `Phase 1/token.cpp`
	- Lexical/token parsing for instructions, registers, immediates, labels, and memory operands.
- `Phase 1/instruction_class.cpp`
	- Encodes instruction formats (R, I, S, SB, UJ).
	- Central place for bitfield assembly.
- `Phase 1/opcodes.h`
	- Opcode and function-code lookup tables.
	- Register name mappings and constants.

### How It Works

The assembler follows a two-pass approach:

1. Pass 1 (symbol discovery)
	 - Scans all lines.
	 - Records label -> address mappings.
	 - Tracks instruction addresses for later branch/jump resolution.

2. Pass 2 (encoding)
	 - Re-parses each instruction line.
	 - Resolves labels to immediate offsets.
	 - Encodes final 32-bit instruction words by format.

3. Output stage
	 - Emits machine code (hex text) in instruction order.
	 - Output can be used to initialize instruction memory for RTL simulation.

### Supported Instruction Families

- R-Type: register-register arithmetic/logical
- I-Type: immediate arithmetic and loads
- S-Type: stores
- SB-Type: conditional branches
- UJ-Type: jumps

Exact mnemonics depend on the lookup/encoding tables in `opcodes.h` and instruction handlers in `instruction_class.cpp`.

### Build and Run

Typical build (from project root):

```bash
g++ "Phase 1/assembler.cpp" "Phase 1/token.cpp" "Phase 1/instruction_class.cpp" -o assembler
```

Run:

```bash
./assembler "Assembler Test Cases/RISC-V Instructions/test1_arithmetic.asm"
```

---

## Phase 2: Pipelined CPU RTL (Verilog)

### Goal

Implement a pipelined RISC-V-like execution core with modular datapath/control, then verify behavior using simulation testbenches.

### Structure

- `Phase 2/rtl/modules/`
	- Reusable building blocks:
		- ALU, ALU control, control unit
		- PC, muxes, immediate generator, shifter, adder
		- register file
- `Phase 2/rtl/memory/`
	- `imem.v`: instruction memory model
	- `dmem.v`: data memory model
- `Phase 2/rtl/stages/`
	- Pipeline stage wrappers:
		- `stage_if.v`: instruction fetch + PC update
		- `stage_id.v`: decode + register read + immediate generation
		- `stage_exe.v`: ALU operation + branch target/condition path
		- `stage_mem.v`: data memory access + branch decision output
		- `stage_wb.v`: writeback data selection
- `Phase 2/rtl/registers/`
	- Pipeline register modules (inter-stage state capture and flush behavior).
- `Phase 2/rtl/top/riscv_core.v`
	- Top-level integration of stage modules.
	- Defines end-to-end signal flow and feedback paths.

### How It Works

Per-cycle conceptual flow:

1. IF stage
	 - Computes next PC (`PC + 4` or branch target).
	 - Fetches instruction from instruction memory.

2. ID stage
	 - Decodes opcode/control intent.
	 - Reads source registers.
	 - Generates sign-extended immediate.

3. EXE stage
	 - Selects ALU operands.
	 - Executes arithmetic/logic or address calculation.
	 - Produces zero/condition information and branch target contribution.

4. MEM stage
	 - Performs load/store against data memory.
	 - Finalizes branch-taken decision signal.

5. WB stage
	 - Selects ALU result vs memory data.
	 - Drives register file writeback path.

### Test and Verification Layout

- `Phase 2/tb/modules/`
	- Unit-level testbenches for combinational/sequential modules and register modules.
- `Phase 2/tb/stages/`
	- Stage-level testbenches for IF/ID/EXE/MEM/WB wrappers.
- `Phase 2/tb/system/`
	- Top-level core smoke/integration testbench.

A combined compile artifact for TB validation is generated as:

- `Phase 2/tb/all_tb_check.out`

---

## Shared Test Assets

Two mirrored test-data locations are present in the repository:

- `Assembler Test Cases/RISC-V Instructions/`
	- Assembly input programs.
- `Assembler Test Cases/Machine Code/`
	- Expected machine code outputs.

Additional top-level copies also exist:

- `RISC-V Instructions/`
- `Machine Code/`

These files are useful for:

1. Assembler correctness checks (Phase 1).
2. Program loading and behavioral testing in RTL simulations (Phase 2).

---

## Recommended End-to-End Workflow

1. Write or choose an `.asm` program from the instruction test set.
2. Run Phase 1 assembler to produce machine code output.
3. Load machine code into instruction memory initialization flow.
4. Run module/stage/system testbenches in Phase 2.
5. Compare observed behavior (register/memory/branch flow) against expected results.

This phase split keeps software translation logic and hardware execution logic independent, while still enabling a complete toolchain-to-core pipeline.
