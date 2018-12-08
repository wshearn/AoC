import haxe.Timer;
import sys.io.File;

/*
Data Format

childrencount metadataCount [0, childrenEnd?(one per childrenCount)] [0, metadataCount]
*/
class Main {
    static function main() {

        var stamp = Timer.stamp();
        var data = File.getContent("input.sample").split(' ');
        data.remove("");
        var parsedData:Array<Int> = [ for (x in 0...data.length) Std.parseInt(data[x]) ];
        var start = 0;
        var part1Result = 0;

        parsedData.reverse();
        var inputIsEven = true;
        if (parsedData.length % 2 != 0) {
            inputIsEven = false;
        }
        trace(parsedData);
        var maxLength = Std.int(Math.abs(parsedData.length/2+1));
        var dataDepth  = [ for (x in 0...maxLength) { "children": 0, "metaData": 0 } ];
        var currentPoint = 0;
        var currentDepth = 0;
        var totalData = 0;
        while (true) {
            while (currentPoint <= parsedData.length-1) {
                trace(parsedData);
                var childNodes = parsedData.pop(); currentPoint++;
                var metaNodes = parsedData.pop(); currentPoint++;
                trace(childNodes);
                trace(dataDepth);
                trace(totalData);

                dataDepth[currentDepth] = {
                    "children": childNodes,
                    "metaData": metaNodes
                };
                trace(currentDepth);
                trace(dataDepth[currentDepth].children);
                for (x in 0...dataDepth[currentDepth].children) {
                    currentDepth++;
                    break;
                }


                for (x in 0 ... dataDepth[currentDepth].metaData) {
                    totalData += parsedData.pop(); currentPoint++;
                }

                currentDepth--;
                trace(parsedData);
            }

            if (currentPoint >= parsedData.length-1) {
                break;
            }
        }
        var stopStamp = Timer.stamp();

        trace("Part 1 Result: " + totalData);
        trace("Part 2 Result: ");
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}
