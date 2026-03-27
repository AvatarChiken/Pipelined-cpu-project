#ifndef INSTRUCTION_TOKEN_H
#define INSTRUCTION_TOKEN_H
#include <token.cpp>
#include <string>
#include <opcodes.h>
#include <cstdint>
#include <unordered_map>
class Instruction {
public:
    virtual ~Instruction() = default;

   
    
};
class  RTypeInstruction : public Instruction 
{
public:

   std::string label;
    std::uint8_t opcode;
    std::uint8_t rd;
    std::uint8_t rs1;
    std::uint8_t rs2;

    RTypeInstruction(Token t)
    { label = t.label;
    opcode = opcodeMap.at(t.opcode).opcode;
    rd = std::stoi(t.operand1.substr(1)); // Assuming operand1 is in the form "xN"
    rs1 = std::stoi(t.operand2.substr(1)); // Assuming operand2 is in the form "xN"
    rs2 = std::stoi(t.operand3.substr(1)); // Assuming operand3 is in the form "xN"
    }
    };
class ITypeInstruction : public Instruction {
public:
    std::string label;
    std::uint8_t opcode;
    std::uint8_t rd;
    std::uint8_t rs1;
    std::int32_t imm;

    ITypeInstruction(Token t)
    {
    label = t.label;
    opcode = opcodeMap.at(t.opcode).opcode;
    rd = std::stoi(t.operand1.substr(1)); // Assuming operand1 is in the form "xN"
    rs1 = std::stoi(t.operand2.substr(1)); // Assuming operand2 is in the form "xN"
    imm = std::stoi(t.operand3); // Assuming operand3 is a signed immediate value
    }
};
class STypeInstruction : public Instruction {
public:
    std::string label;
    std::uint8_t opcode;
    std::uint8_t rs1;
    std::uint8_t rs2;
    std::int32_t imm;

    STypeInstruction(Token t) {
        label = t.label;
        opcode = opcodeMap.at(t.opcode).opcode;
        rs1 = std::stoi(t.operand1.substr(1)); // Assuming operand1 is in the form "xN"
        rs2 = std::stoi(t.operand2.substr(1)); // Assuming operand2 is in the form "xN"
        imm = std::stoi(t.operand3); // Assuming operand3 is a signed immediate value
    }
};
class SBTypeInstruction : public Instruction {
public:
    std::string label;
    std::uint8_t opcode;
    std::uint8_t rs1;
    std::uint8_t rs2;
    std::int32_t imm;

    SBTypeInstruction(Token t, std::unordered_map<std::string, uint32_t> labelAddressMap, uint32_t currentAddress) {
        label = t.label;
        opcode = opcodeMap.at(t.opcode).opcode;
        rs1 = std::stoi(t.operand1.substr(1)); // Assuming operand1 is in the form "xN"
        rs2 = std::stoi(t.operand2.substr(1)); // Assuming operand2 is in the form "xN"
        imm = (labelAddressMap[t.operand3] - currentAddress) / 2; // Calculate the offset to the label
    }
};
class UjTypeInstruction : public Instruction {
public:
    std::string label;
    std::uint8_t opcode;
    std::uint8_t rd;
    std::int32_t imm;

    UjTypeInstruction(Token t , std::unordered_map<std::string, uint32_t> labelAddressMap, uint32_t currentAddress) {
        label = t.label;
        opcode = opcodeMap.at(t.opcode).opcode;
        rd = std::stoi(t.operand1.substr(1)); // Assuming operand1 is in the form "xN"
        imm = (labelAddressMap[t.operand2] - currentAddress) / 2; // Calculate the offset to the label
    }
};
#endif // INSTRUCTION_TOKEN_H

