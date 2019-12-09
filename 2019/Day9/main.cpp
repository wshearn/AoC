#include <iostream>
#include <fstream>
#include <string>
#include <streambuf>

using namespace std;

class IntComputer
{
private:
    /* data */
public:
    long long process(long long data[], long long input)
    {
        long long finalResult = 0;
        int pos = 0;

        while (true)
        {
            long long instruction = data[pos];
            int opcode = (instruction % 100);
            if (opcode == 99) // Exit
            {
                break;
            }

            int num1Ins = (instruction % 1000) / 100;
            int num2Ins = (instruction % 10000) / 1000;

            assert(num1Ins >= 0 && num1Ins <= 2);
            assert(num2Ins >= 0 && num2Ins <= 2);

            long long num1 = 0;
            long long num2 = 0;

            switch (num1Ins)
            {
            case 0:
                num1 = data[data[pos + 1]];
                break;
            case 1:
                num1 = data[pos + 1];
                break;
            case 2:
                break;
            default:
                break;
            }
            switch (num2Ins)
            {
            case 0:
                num2 = data[data[pos + 2]];
                break;
            case 1:
                num2 = data[pos + 1];
                break;
            case 2:
                break;
            default:
                break;
            }

            switch (opcode)
            {
            case 1: // Addition
                data[data[pos + 3]] = num1 + num2;
                pos += 4;
                break;
            case 2: // Multiplication
                data[data[pos + 3]] = num1 * num2;
                pos += 4;
                break;
            case 3: // Input
                data[data[pos + 1]] = input;
                pos += 2;
                break;
            case 4: // Output
                finalResult = num1;
                cout << num1 << endl;
                pos += 2;
                break;
            case 5: // Jump if True
                if (num1 != 0)
                {
                    pos = num2;
                }
                else
                {
                    pos += 3;
                }
                break;
            case 6: // Jump if False
                if (num1 == 0)
                {
                    pos = num2;
                }
                else
                {
                    pos += 3;
                }
                break;
            case 7: // Less than
                if (num1 < num2)
                {
                    data[data[pos + 3]] = 1;
                }
                else
                {
                    data[data[pos + 3]] = 0;
                }
                pos += 4;
                break;
            case 8: // Equals to
                if (num1 == num2)
                {
                    data[data[pos + 3]] = 1;
                }
                else
                {
                    data[data[pos + 3]] = 0;
                }
                pos += 4;
                break;
            default:
                break;
            }
        };

        return finalResult;
    };
    IntComputer(){};
    ~IntComputer(){};
};

int main()
{
    IntComputer *intComputer = new IntComputer();
    ifstream input("input");
    string raw_data((istreambuf_iterator<char>(input)),
                    istreambuf_iterator<char>());

    size_t n = count(raw_data.begin(), raw_data.end(), ',') + 1;

    long long *data;
    data = new long long[n];

    size_t pos = 0;
    string token;
    int count = 0;
    while ((pos = raw_data.find(',')) != string::npos)
    {
        token = raw_data.substr(0, pos);
        raw_data.erase(0, pos + 1);
        data[count] = stoll(token);
        count++;
    }
    data[n - 1] = stoll(raw_data);

    intComputer->process(data, 1);

    return 0;
}
