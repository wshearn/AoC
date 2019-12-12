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
                    output.push(99);
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
                    while (input.empty()) {
                        this_thread::sleep_for(std::chrono::milliseconds(1));
                    }

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

struct Point {
    int x = 0;
    int y = 0;

    bool const operator<(const Point& p) const {
        return x < p.x || (x == p.x && y < p.y);
    }
};

class Robot
{
    public:
        Point position;

        // Direction:
        // 0 = up
        // 1 = left
        // 2 = down
        // 3 = right
        int direction = 0;

        Robot(int x, int y) {
            position.x = x;
            position.y = y;
        }

        void move(int p) {
            if (p == 0) {
                direction += 1;

                if (direction > 3) {
                    direction = 0;
                }
            } else {
                direction -= 1;

                if (direction < 0) {
                    direction = 3;
                }
            }

            switch (direction) {
                case 0: // UP
                    position.x--;
                    break;

                case 1: // Left
                    position.y--;
                    break;

                case 2: // Down
                    position.x++;
                    break;

                case 3: // Right
                    position.y++;
                    break;

                default:
                    break;
            }
        }
};

int main()
{
    ifstream input("input");
    string raw_data((istreambuf_iterator<char>(input)),
                    istreambuf_iterator<char>());

    auto start = chrono::system_clock::now();

    long long *data;
    map<Point, int> canvas;

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

    Point min;
    min.x = 0;
    min.y = 0;
    Point max;
    max.x = 0;
    max.y = 0;
    {
        auto intComputer1 = new IntComputer(data);
        thread thread1 = intComputer1->get_proc_thread();

        Robot *painterBot = new Robot(0, 0);
        canvas.insert(pair<Point, int>(painterBot->position, STARTING_COLOR));
        intComputer1->input.push(canvas[painterBot->position]);

        bool moving = false;

        while (intComputer1->running) {
            if (intComputer1->output.empty()) {
                this_thread::sleep_for(std::chrono::milliseconds(1));
            } else {
                int code = intComputer1->output.front();

                if (code == 99) {
                    break;
                }

                if (moving) {
                    painterBot->move(code);

                    if (canvas.find(painterBot->position) == canvas.end()) {
                        intComputer1->input.push(0);
                    } else {
                        intComputer1->input.push(canvas[painterBot->position]);
                    }

                    if (painterBot->position.x < min.x) {
                        min.x = painterBot->position.x;
                    }

                    if (painterBot->position.x > max.x) {
                        max.x = painterBot->position.x;
                    }

                    if (painterBot->position.y < min.y) {
                        min.y = painterBot->position.y;
                    }

                    if (painterBot->position.y > max.y) {
                        max.y = painterBot->position.y;
                    }


                } else {
                    if (canvas.find(painterBot->position) == canvas.end()) {
                        canvas.insert(pair<Point, int>(painterBot->position, code));
                    } else {
                        canvas[painterBot->position] = code;
                    }
                }

                intComputer1->output.pop();

                moving = !moving;
            }
        }

        thread1.join();
    }

    cout << "Part 1 Answer: " << canvas.size() << endl;

    if (STARTING_COLOR == 1) {
        cout << "Printing part 2 answer.";

        map<Point, int>::iterator it = canvas.begin();

        int currentX = -1000;
        int currentY = 0;

        for (pair<Point, int> element : canvas) {
            if (element.first.x > currentX) {
                currentX = element.first.x;
                currentY = 0;
                cout << endl;
            }

            while (currentY < element.first.y) {
                currentY++;
                cout << " ";
            }

            if (element.second == 0) {
                cout << " ";
            } else {
                cout << "#";
            }

            currentY++;
        }

        cout << endl;
    }

    auto end = chrono::system_clock::now();
    chrono::duration<double> elapsed_seconds = end - start;

    cout << "Time it took to run: " << elapsed_seconds.count() << endl;

    return 0;
}
