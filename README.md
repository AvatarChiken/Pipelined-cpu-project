# RISC-V Assembler

A custom, two-pass RISC-V assembler written in C++ that translates RISC-V assembly source code into 32-bit hexadecimal machine code. This assembler is designed as part of a larger Pipelined CPU project, providing the necessary machine code to run on a custom CPU emulator or instruction memory.

## Features

- **Two-Pass Assembly:** The first pass scans the code to record label addresses and calculate offsets, while the second pass translates the opcodes and operands into machine code.
- **Object-Oriented Design:** Models different RISC-V instruction formats (R-Type, I-Type, S-Type, SB-Type, and UJ-Type) using inheritance and polymorphism for modular encoding.
- **Custom Tokenizer:** Safely parses assembly syntax, mapping opcodes, registers, immediate values, and memory offsets.
- **Machine Code Output:** Automatically generates an `output.hex` file containing the 32-bit zero-padded machine code for seamless integration with simulators.

## Supported Instructions

The assembler currently supports a core subset of base RISC-V instructions:
- **R-Type (Register-Register):** `ADDW`, `AND`, `XOR`, `OR`, `SLTU`, `SRL`, `SRA`
- **I-Type (Immediate):** `ADDIW`, `ANDI`, `ORI`, `LW`, `JALR`
- **S-Type (Store):** `SW`
- **SB-Type (Branch):** `BGE`, `BNE`
- **UJ-Type (Jump):** `JAL`

## Project Structure

- `assembler.cpp`: Entry point containing the core two-pass assembler logic and command-line interface.
- `instruction_class.cpp`: Object-oriented implementations for generating machine code based on instruction types (R, I, S, SB, UJ).
- `token.cpp`: Tokenizer for parsing the assembly source code into digestible components.
- `opcodes.h`: Definitions for opcodes, function codes (funct3/funct7), and register maps.
- `Assembler Test Cases/`: Includes example RISC-V assembly files (`.asm`) and their corresponding expected machine code outputs (`.txt`).

## Building the Assembler

You can compile the assembler using any standard C++ compiler like `g++`. A typical build command looks like this:

```bash
g++ assembler.cpp token.cpp instruction_class.cpp -o assembler
```

*(Note: Depending on how header dependencies are structured, you might just need to compile `assembler.cpp` if it includes the other `.cpp` files directly, but standard compilation links all source files together.)*

Alternatively, use the provided VS Code build task via `Ctrl+Shift+B` if you are using the VS Code environment (`C/C++: g++.exe build active file`).

## Usage

Run the compiled executable and pass your assembly file as a command-line argument:

```bash
./assembler <input_file.asm>
```

**Example:**
```bash
./assembler "Assembler Test Cases/RISC-V Instructions/test1_arithmetic.asm"
```

The assembled machine code will be written to a file named `output.hex` in the current working directory. You can open this file to see the resulting 32-bit hexadecimal instructions.
