import sys.FileSystem;
import haxe.Timer;
import sys.io.File;

class Main {
	public static function main() {
		var part1Answer = 0;
		var part2Answer = 0;

		var inputFile:String = "input";
		if (Sys.args().length > 0 && FileSystem.exists(Sys.args()[0])) {
			inputFile = Sys.args()[0];
		}

		var raw_data = File.getContent(inputFile);

		var stamp = Timer.stamp();
		var stopStamp = Timer.stamp();

		trace("Part 1: " + part1Answer);
		trace("Part 2: " + part2Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
