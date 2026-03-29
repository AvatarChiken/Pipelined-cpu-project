#ifndef TOKEN_H
#define TOKEN_H
#include <iostream>
#include <string>
#include <algorithm>
#include <cctype>

static std::string trim(const std::string& s) {
    const std::string whitespace = " \t\r\n";
    const size_t start = s.find_first_not_of(whitespace);
    if (start == std::string::npos) {
        return "";
    }
    const size_t end = s.find_last_not_of(whitespace);
    return s.substr(start, end - start + 1);
}

static std::string toUpper(std::string s) {
    std::transform(s.begin(), s.end(), s.begin(), [](unsigned char c) {
        return static_cast<char>(std::toupper(c));
    });
    return s;
}

class Token {
public:

std::string label;
std::string opcode;
std::string operand1;
std::string operand2;
std::string operand3;
Token(std::string line)   
    {
        line = trim(line);
        if (line.empty()) {
            return;
        }
 //to handle label:
        size_t colonPos = line.find(':');
        if (colonPos != std::string::npos) {
            label = trim(line.substr(0, colonPos));
            line.erase(0, colonPos + 1); // Remove the label from the line
            line = trim(line);
            if (line.empty()) {
                return;
            }
        }
    // Tokenize the line and populate the opcode, rd, rs1, and rs2 (if type r,)
    line.erase(0, line.find_first_not_of(" \t")); // Trim leading whitespace
    size_t pos = line.find(' ');
    if (pos != std::string::npos) {
        opcode = toUpper(trim(line.substr(0, pos)));
        line.erase(0, pos + 1);
        line = trim(line);
    } else {
        opcode = toUpper(trim(line)); // The entire line is the opcode if no space is found
        return;
    };
    pos = line.find(',');
    if (pos != std::string::npos) {
        operand1 = trim(line.substr(0, pos));
        line.erase(0, pos + 1);
        line = trim(line);
    } else {
        operand1 = trim(line); // The remaining line is operand1 if no comma is found
        return;
    };
    pos = line.find(',');
    if (pos != std::string::npos) {
        operand2 = trim(line.substr(0, pos));
        line.erase(0, pos + 1);
        line = trim(line);
    } else {
        operand2 = trim(line); // The remaining line is operand2 if no comma is found
        operand3.clear();
    };
    if (!line.empty()) {
        pos = line.find(',');
        if (pos != std::string::npos) {
            operand3 = trim(line.substr(0, pos));
            line.erase(0, pos + 1);
            line = trim(line);
        } else {
            operand3 = trim(line); // The remaining line is operand3 if no comma is found
        }
    }

    if(operand2.find('(') != std::string::npos && operand2.find(')') != std::string::npos){
        // This is a type i instruction, we need to extract the offset and the register
        size_t start = operand2.find('(');
        size_t end = operand2.find(')');
        std::string offset = operand2.substr(0, start);
        std::string rs1 = operand2.substr(start + 1, end - start - 1);
        operand2 = trim(offset);
        operand3 = trim(rs1);
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