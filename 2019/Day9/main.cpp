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
        long long process(long long data[], long long input) {
            long long result = 0;
            int pos = 0;
            int base = 0;

            int mode[] = {0, 0, 0};
            long long num[] = {0L, 0L, 0L};

            long long instruction = 0L;
            int opcode = 0;

            int offset = 0;

            while (true) {
                instruction = data[pos];
                opcode = (instruction % 100);

                if (opcode == 99) { // Exit
                    break;
                }

                mode[0] = (instruction % 1000) / 100;
                mode[1] = (instruction % 10000) / 1000;
                mode[2] = (instruction % 100000) / 10000;


                for (int i = 0; i < 3; ++i) {
                    offset = i + 1;

                    switch (mode[i]) {
                        case 1:
                            num[i] = pos + offset;
                            break;

                        case 2:
                            num[i] = data[pos + offset] + base;
                            break;

                        default:
                            num[i] = data[pos + offset];
                            break;
                    }
                }

                switch (opcode) {
                    case 1: // Addition
                        data[num[2]] = data[num[0]] + data[num[1]];
                        pos += 4;
                        break;

                    case 2: // Multiplication
                        data[num[2]] = data[num[0]] * data[num[1]];
                        pos += 4;
                        break;

                    case 3: // Input
                        data[num[0]] = input;
                        pos += 2;
                        break;

                    case 4: // Output
                        result = data[num[0]];
                        pos += 2;
                        break;

                    case 5: // Jump if True
                        data[num[0]] != 0 ? pos = data[num[1]] : pos += 3;
                        break;

                    case 6: // Jump if False
                        data[num[0]] == 0 ? pos = data[num[1]] : pos += 3;
                        break;

                    case 7: // Less than
                        data[num[0]] < data[num[1]] ? data[num[2]] = 1 : data[num[2]] = 0;
                        pos += 4;
                        break;

                    case 8: // Equals to
                        data[num[0]] == data[num[1]] ? data[num[2]] = 1 : data[num[2]] = 0;
                        pos += 4;
                        break;

                    case 9: // Relative base
                        base += data[num[0]];
                        pos += 2;
                        break;

                    default:
                        break;
                }
            };

            return result;
        };
        IntComputer() {};
        ~IntComputer() {};
};

int main()
{
    auto intComputer = new IntComputer();
    ifstream input("input");
    string raw_data((istreambuf_iterator<char>(input)),
                    istreambuf_iterator<char>());

    auto start = chrono::system_clock::now();

    auto n = count(raw_data.begin(), raw_data.end(), ',') + 1;
    auto data = new long long[n];

    size_t pos = 0;
    string token;
    int count = 0;

    while ((pos = raw_data.find(',')) != string::npos) {
        token = raw_data.substr(0, pos);
        raw_data.erase(0, pos + 1);
        data[count] = stoll(token);
        count++;
    }

    data[n - 1] = stoll(raw_data);
    auto part1Answer = intComputer->process(data, 1);
    auto part2Answer = intComputer->process(data, 2);

    auto end = chrono::system_clock::now();
    chrono::duration<double> elapsed_seconds = end - start;

    cout << "Part 1 Answer: " << part1Answer << endl;
    cout << "Part 2 Answer: " << part2Answer << endl;
    cout << "Time it took to run: " << elapsed_seconds.count() << endl;

    return 0;
}
