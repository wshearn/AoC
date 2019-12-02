import haxe.Timer;
import sys.io.File;

class Main {
    public static function main() {
        var part1Answer = 0;
        var part2Answer = 0;

        var totalFuel = 0;

        var fileIn = File.read("input", false);
        var stamp = Timer.stamp();
        try {
            while(true) {
                var line = fileIn.readLine();
                var needed = Std.parseInt(line);
                totalFuel += Math.floor(needed/3)-2;
            }
        } catch (e:haxe.io.Eof) {
            fileIn.close();
        }

        part1Answer = totalFuel;

        // Part 2
        var totalFuelOfFuel = 0;
        fileIn = sys.io.File.read("input", false);
        try {
            while(true) {
                var line = fileIn.readLine();
                var needed = Std.parseInt(line);
                var moduleFuel = 0;
                var currentFuel = 0;
                while(currentFuel >= 0) {
                    currentFuel = Math.floor(needed/3)-2;
                    if (currentFuel > 0) {
                        moduleFuel += currentFuel;
                    }
                    needed = currentFuel;
                }
                totalFuelOfFuel += moduleFuel;
                
            }
        } catch (e:haxe.io.Eof) {
            fileIn.close();
        }
        part2Answer = totalFuelOfFuel;
        var stopStamp = Timer.stamp();

        trace("Part 1: " + part1Answer);
        trace("Part 2: " + part2Answer);
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}