#ifndef OPCODES_H
#define OPCODES_H

#include <string>
#include <unordered_map>
#include <cstdint>

struct OpcodeInfo {
    std::uint8_t opcode;   // primary opcode (hex)
    std::uint8_t funct3;   // funct3 or 0 if not used
    std::uint16_t funct7;   // funct7 or imm LSB when applicable, 0 if not used
};

static const std::unordered_map<std::string, OpcodeInfo> opcodeMap = {
    {"ADDW",  {0x34, 0x01, 0x0010}},
    {"ADDIW", {0x14, 0x01, 0x0000}},
    {"AND",   {0x34, 0x00, 0x0010}},
    {"ANDI",  {0x14, 0x00, 0x0000}},
    {"BGE",   {0x64, 0x06, 0x0000}},
    {"BNE",   {0x64, 0x02, 0x0000}},
    {"JAL",   {0x70, 0x00, 0x0000}},
    {"JALR",  {0x68, 0x01, 0x0000}},
    {"LW",    {0x14, 0x03, 0x0000}},
    {"XOR",   {0x34, 0x05, 0x0010}},
    {"OR",    {0x34, 0x07, 0x0010}},
    {"ORI",   {0x14, 0x07, 0x0000}},
    {"SLTU",  {0x34, 0x04, 0x0001}},
    {"SRL",   {0x34, 0x06, 0x0010}},
    {"SRA",   {0x34, 0x06, 0x0030}},
    {"SW",    {0x24, 0x03, 0x0000}}
};

#endif // OPCODES_H 