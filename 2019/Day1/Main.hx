import haxe.Timer;
import sys.io.File;

class Main {
	public static function part2Recursion(needed:Int, moduleFuel:Int):Int {
		needed = Math.floor(needed / 3) - 2;
		if (needed < 0) {
			return moduleFuel;
		}
		moduleFuel += needed;

		return part2Recursion(needed, moduleFuel);
	}

	public static function main() {
		var part1Answer = 0;
		var part2Answer = 0;

		var fileIn = File.read("input", false);
		var stamp = Timer.stamp();

		var totalFuel = 0;
		var totalFuelOfFuel = 0;
		try {
			while (true) {
				var line = fileIn.readLine();
				var needed = Std.parseInt(line);
				totalFuel += Math.floor(needed / 3) - 2;
				totalFuelOfFuel += Main.part2Recursion(needed, 0);
			}
		} catch (e:haxe.io.Eof) {
			fileIn.close();
		}

		part1Answer = totalFuel;
		part2Answer = totalFuelOfFuel;

		var stopStamp = Timer.stamp();

		Sys.println("Part 1 Answer: " + part1Answer);
		Sys.println("Part 2 Answer: " + part2Answer);
		Sys.println("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
