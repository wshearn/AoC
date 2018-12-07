import haxe.Timer;
import sys.io.File;

class Main {
    static function main() {

        var stamp = Timer.stamp();
        var data = File.getContent("input.sample").split('\n');
        data.remove("");

        data.sort(function(a,b) {
            var asplit = a.split(" ");
            var bsplit = b.split(" ");
            return Reflect.compare(asplit[7], bsplit[7]);
        });

        var steps = new Map<String, Int>();
        for (step in data) {
            var splitStep = step.split(" ");
            steps[splitStep[1]] = data.length;
            steps[splitStep[7]] = data.length;
        }

        var totalSteps = Lambda.count(steps);

        for (step in data) {
            var splitStep = step.split(" ");
            steps[splitStep[1]] -= 1;
            steps[splitStep[7]] += 1;
        }

        var res = "";

        var currentNum = 0; 
        while (res.length < totalSteps) {
            var matchedSteps = new List<String>();

            for (step in steps.keys()) {
                if (steps[step] == currentNum) {
                    matchedSteps.add(step);
                }
            }
            var newSteps = matchedSteps.join(" ").split(" ");
            newSteps.sort(function(a,b){ return Reflect.compare(a,b);});
            res += newSteps.join('');
            currentNum++;
        }

        var stopStamp = Timer.stamp();

        trace("Part 1 Result: " + res);
        trace("Part 2 Result: ");
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}
