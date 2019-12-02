import haxe.Timer;
import sys.io.File;

class Main {
    static var dataFile = "input";
    static var numOfWorkers = 5;

    static function getNextChar(sortedStart:Array<String>, unlocked:List<String>):String {
        var nextChar = "";
        var validChars = sortedStart.length + unlocked.length;
        var charArray:Array<String> = [ for (x in 0...validChars) " " ];

        var currentChar = 0;
        if (sortedStart.length > 0) {
            for (x in sortedStart) {
                charArray[currentChar] = x;
                currentChar++;
            }
        }
        for (x in unlocked) {
            charArray[currentChar] = x;
            currentChar++;
        }

        charArray.sort(function(a,b){ return Reflect.compare(a,b); });
        if (charArray.length > 0) {
            nextChar = charArray[0];
        }

        return nextChar;
    }

    static function main() {

        var stamp = Timer.stamp();
        var data = File.getContent(dataFile).split('\n');
        data.remove("");

        data.sort(function(a,b) {
            var asplit = a.split(" ");
            var bsplit = b.split(" ");
            return Reflect.compare(asplit[7], bsplit[7]);
        });

        var endResult = "";

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
        var maybeOpen = new List<String>();

        var workers = [ for (x in 0...numOfWorkers) { "char": "", "time": 0} ];
        var time = 0;
        while (endResult.length < totalSteps) {

            var reset:Bool = false;
            while (reset == false) {
                for (x in 0...numOfWorkers) {
                    workers[x].time--;
                }

                var finished = [ for (x in 0...numOfWorkers) ""];

                for (x in 0...numOfWorkers) {
                    if (workers[x].time <= 0 && workers[x].char != "") {
                        finished[x] = workers[x].char;
                        workers[x].char = "";
                        workers[x].time = -1;
                    }
                }

                finished.sort(function(a,b){ return Reflect.compare(a,b); });
                endResult += finished.join("");
                if (finished.join("") != "") 
                {
                    reset = true;
                }

                maybeOpen.clear();
                for (step in data) {
                    var splitStep = step.split(" ");
                    var shouldAdd:Bool = true;

                    if (endResult.lastIndexOf(splitStep[1]) != -1) {
                        if (endResult.lastIndexOf(splitStep[7]) == -1) {
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
                            if (endResult.lastIndexOf(splitStep[1]) == -1 ) {
                                maybeOpen.remove(char);
                            }
                        }
                    }
                }

                for (x in 0...numOfWorkers) {
                    for (y in 0...numOfWorkers) {
                        sorted.remove(workers[y].char);
                        maybeOpen.remove(workers[y].char);
                    }
                    if (workers[x].time <= 0) {
                        workers[x].char = getNextChar(sorted, maybeOpen);
                        if (workers[x].char != "") {
                            workers[x].time = workers[x].char.charCodeAt(0) - 4;
                        }
                    }
                }

                time++;
                if (finished.length > 0) { reset = true; }
            }
        }

        var stopStamp = Timer.stamp();

        trace("Result: " + (time-1));
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}
