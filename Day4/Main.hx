import haxe.Timer;
import sys.io.File;

class Main {
    static function increaseSleep(sleepSchedule:Map<Int, Array<Int>>, guard:Int, time:Int) {
        if (sleepSchedule[guard] != null) {
            sleepSchedule[guard][time] += 1;
        } else {
            sleepSchedule[guard] = [ for (x in 0...59) 0 ] ;
            sleepSchedule[guard][time] = 1;
        }
    }
    static function main() {

        var data = File.getContent("input").split('\n');
        //var data = File.getContent("input.sample").split('\n');
        data.remove("");

        var currentGuard:Int = 0;
        var sleepSchedule = new Map<Int, Array<Int>>();
        var totalSlept = new Map<Int, Int>();
        var prevTime = -1;

        var guardOne = {
            "totalSlept": 0,
            "guard": 0,
            "time": 0
        }
        var guardTwo = {
            "time": 0,
            "amount": 0,
            "guard": 0
        }


        var stamp = Timer.stamp();
        for (sleeplog in data) {
            var splitLog = sleeplog.split(' ');
            var strTime = splitLog[1].substring(0, splitLog[1].length-1);
            var time = Std.parseInt(strTime.split(':')[1]);

            if (splitLog[2] == "Guard") {
                currentGuard = Std.parseInt(splitLog[3].substring(1, splitLog[3].length));
                if (totalSlept.exists(currentGuard) == false) {
                    totalSlept[currentGuard] = 0;
                }
            } else if (splitLog[2] == "falls") {
                prevTime = time;
            } else if (splitLog[2] == "wakes") {
                totalSlept[currentGuard] += time-prevTime;
                var max = 0;

                for (x in prevTime...time) {
                    increaseSleep(sleepSchedule, currentGuard, x);

                    if (totalSlept[currentGuard] >= guardOne.totalSlept) {
                        if (sleepSchedule[currentGuard][x] > max) {
                            max = sleepSchedule[currentGuard][x];
                            guardOne.guard = currentGuard;
                            guardOne.time = x;
                            guardOne.totalSlept = totalSlept[currentGuard];
                        }
                    }

                    if (sleepSchedule[currentGuard][x] > guardTwo.amount) {
                        guardTwo.time = x;
                        guardTwo.amount = sleepSchedule[currentGuard][x];
                        guardTwo.guard = currentGuard;
                    }

                }
            }
        }
        var stopStamp = Timer.stamp();

        trace("Part 1 Result: " + guardOne.time * guardOne.guard);
        trace("Part 2 Result: " + guardTwo.time * guardTwo.guard);
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}
