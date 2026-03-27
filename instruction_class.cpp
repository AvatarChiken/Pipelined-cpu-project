#ifndef INSTRUCTION_TOKEN_H
#define INSTRUCTION_TOKEN_H
#include <token.cpp>
#include <string>

#include <cstdint>

class Instruction {
public:

    virtual ~Instruction() = default;

   
};
class  RTypeInstruction : public Instruction {
public:
    std::string opcode;
    std::string rd;
    std::string rs1;
    std::string rs2;

    RTypeInstruction(token t): opcode(t.opcode), rd(t.rd), rs1(t.rs1), rs2(t.rs2) {}
    };
class ITypeInstruction : public Instruction {
public:
    std::string opcode;
    std::string rd;
    std::string rs1;
    std::string imm;

    ITypeInstruction(token t): opcode(t.opcode), rd(t.rd), rs1(t.rs1), imm(t.imm) {}
};
class STypeInstruction : public Instruction {
public:
    std::string opcode;
    std::string rs1;
    std::string rs2;
    std::string imm;

    STypeInstruction(token t): opcode(t.opcode), rs1(t.rs1), rs2(t.rs2), imm(t.imm) {}
};
#endif // INSTRUCTION_TOKEN_H

