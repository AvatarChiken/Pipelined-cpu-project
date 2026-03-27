#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <unordered_map>

#include <opcodes.h>
#include <instruction_class.cpp>
#include <token.cpp>
using  namespace std;
char *filename;
vector<Token> tokens;
vector<Instruction*> instructions;
unordered_map<std::string, uint32_t> labelAddressMap; // Map to store label addresses
uint32_t currentAddress = 0; // Variable to keep track of the current address during the first pass

void tokenize(char* filename)
{
    ifstream file(filename);
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
void  intructionToBinary() {
    for (const auto& instr : instructions) {

        fstream output("output.bin", ios::binary);
    }
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
    firstPass();
    tokenToInstruction();


    return 0;
}