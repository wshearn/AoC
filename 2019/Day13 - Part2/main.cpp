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

int part2Answer = 0;

void redraw(char board[25][30])
{
    system("clear");

    for (int y = 0; y < 25; y++) {
        for (int x = 0; x < 30; x++) {
            cout << board[y][x];
        }

        cout << endl;
    }

    cout << "Score: " << part2Answer << endl;
}

int main()
{
    int part1Answer = 0;
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
        data[0] = 2;
    }

    int paddlex = 22;
    int ballx = 0;

    int lastBlock[3] = {0, 0, 0};
    int ball[3] = {0, 0, 0};
    int move = 1;
    {
        auto intComputer1 = new IntComputer(data);

        thread thread1 = intComputer1->get_proc_thread();

        int currentCount = 0;

        char board[25][30] = { { '.' } };

        while (intComputer1->running) {
            if (intComputer1->waitingForInput && intComputer1->output.empty()) {
                move++;

                if (move <= 2) {
                    intComputer1->input.push(1);
                } else if (move < 389) {
                    intComputer1->input.push(0);
                } else if (move < 409 ) {
                    intComputer1->input.push(-1);
                } else if (move > 873 && move < 890) {
                    intComputer1->input.push(1);
                } else if (move > 1170 && move < 1180) {
                    intComputer1->input.push(1);
                } else if (move > 1383 && move < 1410) {
                    intComputer1->input.push(-1);
                } else {
                    intComputer1->input.push(0);
                }
            } else if (intComputer1->output.empty()) {
                redraw(board);
                this_thread::sleep_for(std::chrono::milliseconds(1));
            } else {
                lastBlock[currentCount] = intComputer1->output.front();
                currentCount++;

                if (currentCount == 3) {
                    redraw(board);

                    switch (intComputer1->output.front()) {
                        case 0:
                            board[lastBlock[1]][lastBlock[0]] = ' ';
                            break;

                        case 1:
                            board[lastBlock[1]][lastBlock[0]] = '#';
                            break;

                        case 2:
                            board[lastBlock[1]][lastBlock[0]] = '@';
                            break;

                        case 3:
                            board[lastBlock[1]][lastBlock[0]] = '^';
                            break;

                        case 4:
                            board[lastBlock[1]][lastBlock[0]] = 'o';
                            break;
                    }

                    if (intComputer1->output.front() == 4) {
                        board[ball[1]][ball[0]] = ' ';
                        ball[0] = lastBlock[0];
                        ball[1] = lastBlock[1];
                        ball[2] = lastBlock[2];
                    } else if (lastBlock[0] == -1 && lastBlock[1] == 0) {

                        part2Answer = lastBlock[2];
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

    cout << "Part 2 Answer: " << move << endl;
    cout << "Time it took to run: " << elapsed_seconds.count() << endl;

    return 0;
}
