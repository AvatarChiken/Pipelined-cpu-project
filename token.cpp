#ifndef TOKEN_H
#define TOKEN_H
#include <iostream>
#include <string>

class Token {
public:


std::string opcode;
std::string operand1;
std::string operand2;
std::string operand3;
Token(std::string line)   
    {
 
    // Tokenize the line and populate the opcode, rd, rs1, and rs2 (if type r,)
    line.erase(0, line.find_first_not_of(" \t")); // Trim leading whitespace
    size_t pos = line.find(' ');
    if (pos != std::string::npos) {
        opcode = line.substr(0, pos);
        line.erase(0, pos + 1);
    } else {
        opcode = line; // The entire line is the opcode if no space is found
        return;
    };
    pos = line.find(',');
    if (pos != std::string::npos) {
        operand1 = line.substr(0, pos);
        line.erase(0, pos + 1);
    } else {
        operand1 = line; // The remaining line is operand1 if no comma is found
        return;
    };
    pos = line.find(',');
    if (pos != std::string::npos) {
        operand2 = line.substr(0, pos);
        line.erase(0, pos + 1);
    } else {
        operand2 = line; // The remaining line is operand2 if no comma is found
        return;
    };
    pos = line.find(',');
    if (pos != std::string::npos) {
        operand3 = line.substr(0, pos);
        line.erase(0, pos + 1);
    } else {
        operand3 = line; // The remaining line is operand3 if no comma is found
    }

    if(operand2.find('(') != std::string::npos && operand2.find(')') != std::string::npos){
        // This is a type i instruction, we need to extract the offset and the register
        size_t start = operand2.find('(');
        size_t end = operand2.find(')');
        std::string offset = operand2.substr(0, start);
        std::string rs1 = operand2.substr(start + 1, end - start - 1);
        operand2 = offset;
        operand3 = rs1;
    }
};    
void print() {
    std::cout << "Opcode: " << opcode << std::endl;
    std::cout << "Operand 1: " << operand1 << std::endl;
    std::cout << "Operand 2: " << operand2 << std::endl;
    std::cout << "Operand 3: " << operand3 << std::endl;
};

};

#endif // TOKEN_H