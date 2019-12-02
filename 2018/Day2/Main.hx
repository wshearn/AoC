import haxe.Timer;
import sys.io.File;

class Main {
    static function main() {
        var two = 0;
        var three = 0;
        
        var currentMatch = {
            "key1": 0,
            "key2": 0,
            "diff": 9999
        }

        var data = File.getContent("input").split('\n');
        data.remove("");

        var stamp = Timer.stamp();
        for (x in 0...data.length) {
            // Part 1
            var nextCode:Int = x+1;
            var labelHash = new Map<String, Int>();
            var idSplit = data[x].split("");
            for (char in idSplit) {
                if (!labelHash.exists(char)) {
                    labelHash[char] = 1;
                } else {
                    labelHash[char] += 1;
                }
            }
            
            var twoUsed:Bool = false;
            var threeUsed:Bool = false;
            for (char in labelHash.keys()) {
                if (!twoUsed && labelHash[char] == 2) {
                    two++;
                    twoUsed = true;
                } else if (!threeUsed && labelHash[char] == 3) {
                    three++;
                    threeUsed = true;
                }
                
                if (threeUsed && twoUsed) {
                    break;
                }
            }
            // End Part 1

            // Part 2
            for (y in nextCode...data.length) {
                var diff:Int = 0;
                var same:String = "";
                for (z in 0...data[x].length) {
                    if (data[x].charAt(z) != data[y].charAt(z)) {
                        diff += 1;
                        if (diff > currentMatch.diff) {
                            continue;
                        }
                    }
                }
                if (currentMatch.diff > diff) {
                    currentMatch.diff = diff;
                    currentMatch.key1 = x;
                    currentMatch.key2 = y;
                }
            }
            // End Part 2
        }
        // Part 2 - Get Common chars
        var sameKey = "";
        for (x in 0...data[currentMatch.key1].length) {
            if (data[currentMatch.key1].charAt(x) == data[currentMatch.key2].charAt(x)) {
                sameKey += data[currentMatch.key1].charAt(x);
            }
        }
        // End Part 2

        var stopStamp = Timer.stamp();

        trace("Checksum: " + (two * three));
        trace("Same key: " + sameKey);
        trace("Time in seconds it took to run part1: " + (stopStamp-stamp));
    }
}
