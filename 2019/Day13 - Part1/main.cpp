#include <fstream>
#include <iostream>
#include <streambuf>
#include <string>
#include <chrono>
#include <queue>
#include <mutex>
#include <thread>
#include <condition_variable>
#include <map>
#include <stdlib.h>

using namespace std;

#define STARTING_COLOR 1

class IntComputer
{
    public:
        queue<long long> input;
        queue<long long> output;

        bool running = true;
        bool waitingForInput = false;

        void process() {
            int pos = 0;
            int base = 0;
            running = true;

            int mode[] = {0, 0, 0};
            long long num[] = {0L, 0L, 0L};

            long long instruction = 0L;
            int opcode = 0;
            int offset = 0;


            while (true) {
                instruction = data[pos];
                opcode = (instruction % 100);

                if (opcode == 99) { // Exit
                    while (!output.empty()) {
                        this_thread::sleep_for(std::chrono::milliseconds(1));
                    }

                    running = false;
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


                if (opcode == 1 ) { // Addition
                    data[num[2]] = data[num[0]] + data[num[1]];
                    pos += 4;
                } else if (opcode == 2) { // Multiplication
                    data[num[2]] = data[num[0]] * data[num[1]];
                    pos += 4;
                } else if (opcode == 3) { // Input
                    waitingForInput = true;

                    while (input.empty()) {
                        cout << "Waiting for input..." << endl;
                        this_thread::sleep_for(std::chrono::milliseconds(1));
                    }

                    waitingForInput = false;
                    data[num[0]] = input.front();
                    input.pop();
                    pos += 2;
                } else if (opcode == 4) { // Output
                    output.push(data[num[0]]);
                    pos += 2;
                } else if (opcode == 5) { // Jump if True
                    data[num[0]] != 0 ? pos = data[num[1]] : pos += 3;
                } else if (opcode == 6) { // Jump if False
                    data[num[0]] == 0 ? pos = data[num[1]] : pos += 3;
                } else if (opcode == 7) { // Less than
                    data[num[0]] < data[num[1]] ? data[num[2]] = 1 : data[num[2]] = 0;
                    pos += 4;
                } else if (opcode == 8) { // Equals to
                    data[num[0]] == data[num[1]] ? data[num[2]] = 1 : data[num[2]] = 0;
                    pos += 4;
                } else if (opcode == 9) { // Relative base
                    base += data[num[0]];
                    pos += 2;
                }
            };
        };
        thread get_proc_thread() {
            return thread([ = ] { process(); });
        }
        IntComputer(long long data[]) {
            this->data = data;
        };
        ~IntComputer() {};
    private:
        long long *data;
};

int main()
{
    int part1Answer = 0;
    int part2Answer = 0;
    ifstream input("input");
    string raw_data((istreambuf_iterator<char>(input)),
                    istreambuf_iterator<char>());

    auto start = chrono::system_clock::now();

    long long *data;

    {
        auto n = count(raw_data.begin(), raw_data.end(), ',') + 1;
        data = new long long[n];

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
    }

    {
        auto intComputer1 = new IntComputer(data);
        thread thread1 = intComputer1->get_proc_thread();

        int currentCount = 0;

        while (intComputer1->running) {
            if (intComputer1->output.empty()) {
                this_thread::sleep_for(std::chrono::milliseconds(1));
            } else {
                currentCount++;

                if (currentCount == 3) {
                    if (intComputer1->output.front() == 2) {
                        part1Answer++;
                    }

                    currentCount = 0;
                }

                intComputer1->output.pop();
            }
        }

        thread1.join();
    }

    auto end = chrono::system_clock::now();
    chrono::duration<double> elapsed_seconds = end - start;

    cout << "Part 1 Answer: " << part1Answer << endl;
    cout << "Time it took to run: " << elapsed_seconds.count() << endl;

    return 0;
}
