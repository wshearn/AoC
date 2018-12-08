import haxe.Timer;
import sys.io.File;

class Main {
    static function main() {

        var stamp = Timer.stamp();
        var data = File.getContent("input").split('\n');
        data.remove("");

        data.sort(function(a,b) {
            var asplit = a.split(" ");
            var bsplit = b.split(" ");
            return Reflect.compare(asplit[7], bsplit[7]);
        });

        var part1Res = "";

        var totalStepsMap = new Map<String, Int>();
        var leftList = new Map<String, Int>();
        var rightList = new Map<String, Int>();

        for (step in data) {
            var splitStep = step.split(" ");

            leftList[splitStep[1]] = 1;
            rightList[splitStep[7]] = 1;

            totalStepsMap[splitStep[1]] = 1;
            totalStepsMap[splitStep[7]] = 1;

        }

        var totalSteps = Lambda.count(totalStepsMap);

        for (key in rightList.keys()) {
            leftList.remove(key);
        }

        var unSorted = "";
        for (key in leftList.keys()) {
            unSorted += key;
        }
        var sorted = unSorted.split("");
        sorted.sort(function(a,b){ return Reflect.compare(a, b); });
        part1Res += sorted[0];
        sorted.remove(sorted[0]);

        var maybeOpen = new List<String>();
        while (part1Res.length < totalSteps) {

            var reset:Bool = false;
            while (reset == false) {
                for (step in data) {
                    var splitStep = step.split(" ");
                    var shouldAdd:Bool = true;

                    if (part1Res.lastIndexOf(splitStep[1]) != -1) {
                        if (part1Res.lastIndexOf(splitStep[7]) == -1) {
                            for (x in maybeOpen) {
                                if (x == splitStep[7]) {
                                    shouldAdd = false;
                                }
                            }
                        } else {
                            shouldAdd = false;
                        }
                    }
                    if (shouldAdd) {
                        maybeOpen.add(splitStep[7]);
                    }
                }

                for (step in data) {
                   var splitStep = step.split(" ");

                    for (char in maybeOpen) {
                        if (splitStep[7] == char) {
                            if (part1Res.lastIndexOf(splitStep[1]) == -1 ) {
                                maybeOpen.remove(char);
                            }
                        }
                    }
                }
                var nextChar = "";
                var validChars = sorted.length + maybeOpen.length;
                var charArray:Array<String> = [ for (x in 0...validChars) " " ];
                var currentChar = 0;
                if (sorted.length > 0) {
                    for (x in sorted) {
                        charArray[currentChar] = x;
                        currentChar++;
                    }
                }
                for (x in maybeOpen) {
                    charArray[currentChar] = x;
                    currentChar++;
                }
                maybeOpen.clear();

                charArray.sort(function(a,b){ return Reflect.compare(a,b); });
                if (charArray.length > 0) {
                    nextChar = charArray[0];

                    part1Res += nextChar;
                    sorted.remove(nextChar);
                    reset = true;
                }
            }
        }

        var stopStamp = Timer.stamp();

        trace("Part 1 Result: " + part1Res);
        trace("Part 2 Result: ");
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}
