import haxe.Timer;
import sys.io.File;

class Main {
    static function getMetaCount(start:Int = 0, parsedData:Array<Int>):Array<Int> {
        var childCount = parsedData[start];
        var metaCount = parsedData[start+1];
        var totalMeta = 0;
        var metaStart = start+2;
        var size = 2; // Min size is 2

        var nextChildStart = 0;
        if (childCount == 0) {
            nextChildStart += start+metaCount;
        } else {
            nextChildStart += start+2;
        }

        for (x in 0...childCount) {
            var result = getMetaCount(nextChildStart, parsedData);
            nextChildStart += result[0];
            totalMeta += result[1];
            metaStart += result[2];
            size += result[2]; // Increase size by the size of the child
        }

        trace("size: " + size + " - metaCount: " + metaCount);

        size += metaCount; // Add how many metadata items we have to size

        for (x in 0...metaCount) {
            totalMeta += parsedData[metaStart + x];
        }

        var res = new Array();
        res.push(nextChildStart);
        res.push(totalMeta); // Meta amount
        res.push(size);
        return res;
    }
    static function main() {

        var stamp = Timer.stamp();
        var data = File.getContent("input.sample").split(' ');
        data.remove("");
        var parsedData:Array<Int> = [ for (x in 0...data.length) Std.parseInt(data[x]) ];
        var start = 0;
        var part1Result = 0;
        while (true) {
            if (start >= data.length) {
                break;
            }

            var result = getMetaCount(start, parsedData);
            part1Result += result[1];
            start += result[2];
        }

        var stopStamp = Timer.stamp();

        trace("Part 1 Result: " + part1Result);
        trace("Part 2 Result: ");
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}
