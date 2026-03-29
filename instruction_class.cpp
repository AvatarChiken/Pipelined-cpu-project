#ifndef INSTRUCTION_TOKEN_H
#define INSTRUCTION_TOKEN_H
#include "token.cpp"
#include <string>
#include "opcodes.h"
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
    std::uint8_t funct3;
    std::uint16_t funct7;
    std::uint8_t rd;
    std::uint8_t rs1;
    std::uint8_t rs2;

    RTypeInstruction(Token t)
    { label = t.label;
    const OpcodeInfo& info = opcodeMap.at(t.opcode);
    opcode = info.opcode;
    funct3 = info.funct3;
    funct7 = info.funct7;
    rd = std::stoi(t.operand1.substr(1));
    rs1 = std::stoi(t.operand2.substr(1)); 
    rs2 = std::stoi(t.operand3.substr(1)); 
    }
    };
class ITypeInstruction : public Instruction {
public:
    std::string label;
    std::uint8_t opcode;
    std::uint8_t funct3;
    std::uint8_t rd;
    std::uint8_t rs1;
    std::int32_t imm;

    ITypeInstruction(Token t)
    {
    label = t.label;
    const OpcodeInfo& info = opcodeMap.at(t.opcode);
    opcode = info.opcode;
    funct3 = info.funct3;
    rd = std::stoi(t.operand1.substr(1)); 
    if (t.opcode == "LW") {
        imm = std::stoi(t.operand2); 
        rs1 = std::stoi(t.operand3.substr(1));
    } else {
        rs1 = std::stoi(t.operand2.substr(1)); 
        imm = std::stoi(t.operand3); // Assuming operand3 is a signed immediate value
    }
    }
};
class STypeInstruction : public Instruction {
public:
    std::string label;
    std::uint8_t opcode;
    std::uint8_t funct3;
    std::uint8_t rs1;
    std::uint8_t rs2;
    std::int32_t imm;

    STypeInstruction(Token t) {
        label = t.label;
        const OpcodeInfo& info = opcodeMap.at(t.opcode);
        opcode = info.opcode;
        funct3 = info.funct3;
        rs2 = std::stoi(t.operand1.substr(1)); // SW syntax: sw rs2, imm(rs1)
        imm = std::stoi(t.operand2);
        rs1 = std::stoi(t.operand3.substr(1));
    }
};
class SBTypeInstruction : public Instruction {
public:
    std::string label;
    std::uint8_t opcode;
    std::uint8_t funct3;
    std::uint8_t rs1;
    std::uint8_t rs2;
    std::int32_t imm;

    SBTypeInstruction(Token t, std::unordered_map<std::string, uint32_t> labelAddressMap, uint32_t currentAddress) {
        label = t.label;
        const OpcodeInfo& info = opcodeMap.at(t.opcode);
        opcode = info.opcode;
        funct3 = info.funct3;
        rs1 = std::stoi(t.operand1.substr(1));
        rs2 = std::stoi(t.operand2.substr(1)); 
        imm = static_cast<std::int32_t>(labelAddressMap[t.operand3]) - static_cast<std::int32_t>(currentAddress); // byte offset to label
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
        rd = std::stoi(t.operand1.substr(1)); 
        imm = static_cast<std::int32_t>(labelAddressMap[t.operand2]) - static_cast<std::int32_t>(currentAddress); // byte offset to label
    }
};
#endif 

