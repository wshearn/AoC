import haxe.Timer;
import sys.io.File;

class Main {

    public static function main() {
        var part1Answer = 0;
        var part2Answer = 0;

        var raw_data = File.getContent("input");

        var stamp = Timer.stamp();
        var stopStamp = Timer.stamp();

        trace("Part 1: " + part1Answer);
        trace("Part 2: " + part2Answer);
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}