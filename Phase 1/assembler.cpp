#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <unordered_map>
#include <iomanip>

#include "opcodes.h"
#include "instruction_class.cpp"
#include "token.cpp"
using  namespace std;
char *filename;
vector<Token> tokens;
vector<Instruction*> instructions;
unordered_map<std::string, uint32_t> labelAddressMap; // Map to store label addresses
uint32_t currentAddress = 0; // Variable to keep track of the current address during the first pass

void tokenize(char* filename)
{
    ifstream file(filename);
        if (!file.is_open()) {
                cerr << "Error: Cannot open input file: " << filename << endl;
                return;
        }

    string line;
      while (getline(file, line))
        {
          Token token(line);
          token.print();
          tokens.push_back(token);
        }
} 
void firstPass() {
    for (const auto& token : tokens) {
        if (!token.label.empty()) {
            labelAddressMap[token.label] = currentAddress; // Store the address of the label
        }
        if (!token.opcode.empty()) {
            currentAddress += 4; // Assuming each instruction is 4 bytes
        }
    }
}
void tokenToInstruction() {
    uint32_t instAddress = 0;
    for (const auto& token : tokens) {
        if (token.opcode.empty()) continue; // Skip if it's just a label line

        if (opcodeMap.find(token.opcode) == opcodeMap.end()) {
            cerr << "Error: Unknown opcode " << token.opcode << endl;
            continue;
        }
        
        const OpcodeInfo& info = opcodeMap.at(token.opcode);

        if (info.opcode == 0x34) { // R-type instructions (ADDW, AND, XOR, OR, SLTU, SRL, SRA)
            instructions.push_back(new RTypeInstruction(token));
        } else if (info.opcode == 0x14 || info.opcode == 0x68 || info.opcode == 0x03) { // I-type instructions (ADDIW, ANDI, ORI, LW, JALR)
            instructions.push_back(new ITypeInstruction(token));
        } else if (info.opcode == 0x24) { // S-type instructions (SW)
            instructions.push_back(new STypeInstruction(token));
        } else if (info.opcode == 0x64) { // SB-type instructions (BGE, BNE)
            instructions.push_back(new SBTypeInstruction(token, labelAddressMap, instAddress));
        } else if (info.opcode == 0x70) { // UJ-type instructions (JAL)
            instructions.push_back(new UjTypeInstruction(token, labelAddressMap, instAddress));
        } else {
            cerr << "Warning: Instruction logic unhandled for " << token.opcode << endl;
        }
        
        instAddress += 4;
    }
}
void  intructionToHex() {
    if (instructions.empty()) {
        cerr << "Error: No instructions were encoded. Check input file and opcode spelling." << endl;
        return;
    }

    ofstream output("output.hex");
    if (!output.is_open()) {
        cerr << "Error: Unable to open output.hex for writing" << endl;
        return;
    }

    for (const auto& instr : instructions) {
        uint32_t machineCode = 0;

        if (const auto* r = dynamic_cast<RTypeInstruction*>(instr)) {
            machineCode = ((static_cast<uint32_t>(r->funct7) & 0x7F) << 25) |
                          ((static_cast<uint32_t>(r->rs2) & 0x1F) << 20) |
                          ((static_cast<uint32_t>(r->rs1) & 0x1F) << 15) |
                          ((static_cast<uint32_t>(r->funct3) & 0x07) << 12) |
                          ((static_cast<uint32_t>(r->rd) & 0x1F) << 7) |
                          (static_cast<uint32_t>(r->opcode) & 0x7F);
        } else if (const auto* i = dynamic_cast<ITypeInstruction*>(instr)) {
            machineCode = ((static_cast<uint32_t>(i->imm) & 0xFFF) << 20) |
                          ((static_cast<uint32_t>(i->rs1) & 0x1F) << 15) |
                          ((static_cast<uint32_t>(i->funct3) & 0x07) << 12) |
                          ((static_cast<uint32_t>(i->rd) & 0x1F) << 7) |
                          (static_cast<uint32_t>(i->opcode) & 0x7F);
        } else if (const auto* s = dynamic_cast<STypeInstruction*>(instr)) {
            machineCode = (((static_cast<uint32_t>(s->imm) >> 5) & 0x7F) << 25) |
                          ((static_cast<uint32_t>(s->rs2) & 0x1F) << 20) |
                          ((static_cast<uint32_t>(s->rs1) & 0x1F) << 15) |
                          ((static_cast<uint32_t>(s->funct3) & 0x07) << 12) |
                          ((static_cast<uint32_t>(s->imm) & 0x1F) << 7) |
                          (static_cast<uint32_t>(s->opcode) & 0x7F);
        } else if (const auto* sb = dynamic_cast<SBTypeInstruction*>(instr)) {
            uint32_t imm = static_cast<uint32_t>(sb->imm) & 0x1FFF;
            machineCode = (((imm >> 12) & 0x1) << 31) |
                          (((imm >> 5) & 0x3F) << 25) |
                          ((static_cast<uint32_t>(sb->rs2) & 0x1F) << 20) |
                          ((static_cast<uint32_t>(sb->rs1) & 0x1F) << 15) |
                          ((static_cast<uint32_t>(sb->funct3) & 0x07) << 12) |
                          (((imm >> 1) & 0xF) << 8) |
                          (((imm >> 11) & 0x1) << 7) |
                          (static_cast<uint32_t>(sb->opcode) & 0x7F);
        } else if (const auto* uj = dynamic_cast<UjTypeInstruction*>(instr)) {
            uint32_t imm = static_cast<uint32_t>(uj->imm) & 0x1FFFFF;
            machineCode = (((imm >> 20) & 0x1) << 31) |
                          (((imm >> 1) & 0x3FF) << 21) |
                          (((imm >> 11) & 0x1) << 20) |
                          (((imm >> 12) & 0xFF) << 12) |
                          ((static_cast<uint32_t>(uj->rd) & 0x1F) << 7) |
                          (static_cast<uint32_t>(uj->opcode) & 0x7F);
        } else {
            cerr << "Warning: Unknown instruction type encountered during encoding" << endl;
            continue;
        }

        output << std::uppercase << std::hex << std::setw(8) << std::setfill('0') << machineCode << '\n';
    }

    output.close();
}


int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        cout << "Usage: assembler <filename>" << endl;
        return 1;
    }
    filename = argv[1];
    tokenize(filename);
    if (tokens.empty()) {
        cerr << "Error: No tokens parsed from input. Nothing to assemble." << endl;
        return 1;
    }

    firstPass();
    tokenToInstruction();
    intructionToHex();


    return 0;
}