#include <iostream>
#include <fstream>
#include <string>
#include <instruction_class.cpp>
#include <token.cpp>
#include <vector>
using  namespace std;
char *filename;
vector<Token> tokens;
vector<Instruction> instructions;

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
void tokentoInstruction(vector<Token> t)
{
   
    
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

    return 0;
}