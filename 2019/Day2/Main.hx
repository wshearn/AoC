import haxe.Timer;
import sys.io.File;

class Main {
    public static function process(data:Array<Int>):Int {
        var pos = 0;
        while(true) {
            var opcode = data[pos];
            if (opcode == 99) {
                break;
            }
            var pos1 = data[pos+1];
            var pos2 = data[pos+2];
            var pos3 = data[pos+3];

            var num1 = data[pos1];
            var num2 = data[pos2];

            switch opcode{
                case 1:
                    data[pos3] = num1+num2;
                    
                case 2:
                    data[pos3] = num1*num2;
            }
            pos += 4;
        }

        return data[0];
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
        p1Data[1] = 12;
        p1Data[2] = 2;
        part1Answer = Main.process(p1Data);
    
        for (noun in 1...100) {
            var verb = 50;
            var minVerb = 0;
            var maxVerb = 99;
            var usedVerbs:Map<Int, Bool> = new Map<Int, Bool>();
            var slowCount = false;

            while (true) {
                var p2Res:Int = 0;
                var p2Data = data.copy();
                p2Data[1] = noun;
                p2Data[2] = verb;

                usedVerbs[verb] = true;

                try {
                    p2Res = Main.process(p2Data);
                } catch(e:Dynamic) {
                    p2Res = part2Wanted - 1;
                }

                if (p2Res == part2Wanted) {
                    part2Answer = (noun * 100) + verb;
                    break;
                } else if (p2Res > part2Wanted) {
                    maxVerb = verb;
                    verb = minVerb;
                    slowCount = true;
                    break;
                } else if (p2Res < part2Wanted) {
                    minVerb = verb;
                    var diff = maxVerb - minVerb;
                    verb = Math.floor(diff*2);
                }

                if (verb < 0 || verb > 99) {
                    break;
                }

                if (usedVerbs[verb] == true) {
                    break;
                }
            }
            while (slowCount) {
                var p2Res:Int = 0;
                var p2Data = data.copy();
                p2Data[1] = noun;
                p2Data[2] = verb;

                if (verb >= maxVerb) {
                    break;
                }

                try {
                    p2Res = Main.process(p2Data);
                } catch(e:Dynamic) {
                    p2Res = part2Wanted - 1;
                }

                if (p2Res == part2Wanted) {
                    part2Answer = (noun * 100) + verb;
                    break;
                }

                verb = verb + 1;
                if (verb > maxVerb) {
                    slowCount = false;
                }
            } 
            slowCount = false;
            if (part2Answer != -1) {
                break;
            }
        }
        var stopStamp = Timer.stamp();

        trace("Part 1: " + part1Answer);
        trace("Part 2: " + part2Answer);
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}