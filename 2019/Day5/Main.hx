import haxe.Timer;
import sys.io.File;

class Main {
    public static function process(data:Array<Int>):Int {
        var finalResult = 0;
        var pos = 0;

        while(true) {
            var instruction = data[pos];

            var opcode = Math.floor((instruction % 100));
            if (opcode == 99) {
                break;
            }

            var num1Ins = Math.floor((instruction % 1000)/100);
            var num2Ins = Math.floor((instruction % 10000)/1000);
            var num3Ins = Math.floor((instruction % 100000)/10000);

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

            var result = 0;

            switch opcode{
                case 1:
                    result = num1+num2;
                case 2:
                    result = num1*num2;
                case 3:
                    var input = 1;
                    result = input;
                case 4:
                    finalResult = num1;
                    if (data[pos+2] != 99) {
                        Assertion.assert(finalResult == 0);
                    }
            }

            if (num3Ins == 0 || opcode == 3) {
                data[data[pos+3]] = result;
            } else if (num3Ins == 1) {
                data[pos+3] = result;
            }

            if (opcode >= 3) {
                pos += 2;
            } else {
                pos += 4;
            }
        }

        return finalResult;
    }

    public static function main() {
        var part1Answer = 0;
        var part2Answer = -1;
        var part2Wanted = 19690720;

        // Part 1
        var raw_data = File.getContent("input");
        var string_data = raw_data.split(",");
        var data:Array<Int> = new Array<Int>();
        for (x in 0...string_data.length) {
            data.push(Std.parseInt(string_data[x]));
        }
        
        var stamp = Timer.stamp();

        var p1Data = data.copy();
        part1Answer = Main.process(p1Data);

        var stopStamp = Timer.stamp();

        trace("Part 1: " + part1Answer);
        trace("Part 2: " + part2Answer);
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}