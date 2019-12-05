import haxe.Timer;
import sys.io.File;

class Main {
    public static function process(data:Array<Int>, input:Int):Int {
        var finalResult = 0;
        var pos = 0;

        while(true) {
            var jmpPos = 0;
            Assertion.assert(data[pos] != null);
            var instruction = data[pos];

            var opcode = Math.floor((instruction % 100));

            if (opcode == 99) {
                break;
            }

            var num1Ins = Math.floor((instruction % 1000)/100);
            var num2Ins = Math.floor((instruction % 10000)/1000);

            Assertion.assert(num1Ins == 0 || num1Ins == 1);
            Assertion.assert(num2Ins == 0 || num2Ins == 1);

            var num1:Int = 0;
            var num2:Int = 0;

            if (num1Ins == 0) {
                num1 = data[data[pos+1]];
            } else if (num1Ins == 1) {
                num1 = data[pos+1];
            }

            if (num2Ins == 0) {
                num2 = data[data[pos+2]];
            } else if (num2Ins == 1) {
                num2 = data[pos+2];
            }

            switch opcode{
                case 1: //Addation
                    data[data[pos+3]] = num1+num2;
                    jmpPos = 4;
                case 2: //Multiplication 
                    data[data[pos+3]] = num1*num2;
                    jmpPos = 4;
                case 3: //Input
                    data[data[pos+3]] = input;
                    jmpPos = 2;
                case 4: //Output
                    finalResult = num1;
                    if (data[pos+2] != 99) {
                        Assertion.assert(finalResult == 0);
                    }
                    jmpPos = 2;
                case 5: //Jump if true
                    if (num1 != 0) {
                        jmpPos = num2;
                    } else {
                        jmpPos = 3;
                    }
                case 6: //Jump if false
                    if (num1 == 0) {
                        jmpPos = num2;
                    } else {
                        jmpPos = 3;
                    }
                case 7: // Less than
                    if (num1 < num2) {
                        data[data[pos+3]] = 1;
                     } else {
                        data[data[pos+3]] = 0;
                     }
                    jmpPos = 4;
                case 8: // Equals than
                    if (num1 == num2) {
                        data[data[pos+3]] = 1;
                     } else {
                        data[data[pos+3]] = 0;
                     }
                    jmpPos = 4;
                case 99:
                    break;
            }

            pos += jmpPos;
        }

        return finalResult;
    }

    public static function main() {
        var part1Answer = 0;
        var part2Answer = -1;

        // Part 1
        var raw_data = File.getContent("input");
        var string_data = raw_data.split(",");
        var data:Array<Int> = new Array<Int>();
        for (x in 0...string_data.length) {
            data.push(Std.parseInt(string_data[x]));
        }
        
        var stamp = Timer.stamp();

        var p1Data = data.copy();
        var p2Data = data.copy();
        part1Answer = Main.process(p1Data, 1);
        part2Answer = Main.process(p2Data, 5);
        var stopStamp = Timer.stamp();

        trace("Part 1: " + part1Answer);
        trace("Part 2: " + part2Answer);
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}