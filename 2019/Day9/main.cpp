#include <fstream>
#include <iostream>
#include <streambuf>
#include <string>
#include <chrono>

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
        int relativeBase = 0;

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
            int num3Ins = (instruction % 100000) / 10000;
            long long num1 = 0;
            long long num2 = 0;
            long long num3 = 0;

            switch (num1Ins)
            {
            case 1:
                num1 = pos + 1;
                break;
            case 2:
                num1 = data[pos + 1] + relativeBase;
                break;
            default:
                num1 = data[pos + 1];
                break;
            }
            switch (num2Ins)
            {
            case 1:
                num2 = pos + 2;
                break;
            case 2:
                num2 = data[pos + 2] + relativeBase;
                break;
            default:
                num2 = data[pos + 2];
                break;
            }

            switch (num3Ins)
            {
            case 1:
                num3 = pos + 3;
                break;
            case 2:
                num3 = data[pos + 3] + relativeBase;
                break;
            default:
                num3 = data[pos + 3];
                break;
            }

            switch (opcode)
            {
            case 1: // Addition
                data[num3] = data[num1] + data[num2];
                pos += 4;
                break;
            case 2: // Multiplication
                data[num3] = data[num1] * data[num2];
                pos += 4;
                break;
            case 3: // Input
                data[num1] = input;
                pos += 2;
                break;
            case 4: // Output
                finalResult = data[num1];
                pos += 2;
                break;
            case 5: // Jump if True
                data[num1] != 0 ? pos = data[num2] : pos += 3;
                break;
            case 6: // Jump if False
                data[num1] == 0 ? pos = data[num2] : pos += 3;
                break;
            case 7: // Less than
                data[num1] < data[num2] ? data[num3] = 1 : data[num3] = 0;
                pos += 4;
                break;
            case 8: // Equals to
                data[num1] == data[num2] ? data[num3] = 1 : data[num3] = 0;
                pos += 4;
                break;
            case 9: // Relative base
                relativeBase += data[num1];
                pos += 2;
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

    auto start = std::chrono::system_clock::now();

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

    long long part1Answer = intComputer->process(data, 1);
    long long part2Answer = intComputer->process(data, 2);

    auto end = std::chrono::system_clock::now();
    std::chrono::duration<double> elapsed_seconds = end-start;
    std::time_t end_time = std::chrono::system_clock::to_time_t(end);

    cout << "Part 1 Answer: " << part1Answer << endl;
    cout << "Part 2 Answer: " << part2Answer << endl;
    cout << "Time it took to run: " << elapsed_seconds.count() << endl;

    return 0;
}
