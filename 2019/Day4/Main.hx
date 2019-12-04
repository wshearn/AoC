import sys.db.Mysql;
import sys.thread.Thread;
import haxe.Timer;
import sys.io.File;

class Main {
	public static function main() {
		var part1Answer = 0;
		var part2Answer = 0;

		var input = [109165, 576723];

		var stamp = Timer.stamp();

		for (x in input[0]...input[1]) {
			var numInString = "" + x;

			var part2Array = [0,0,0,0,0,0,0,0,0,0];

			var valid = false;
			for (place in 0...numInString.length - 1) {
				var currChar = numInString.charCodeAt(place);
				var nextChar = numInString.charCodeAt(place + 1);

				if (currChar == nextChar) {
					valid = true;
				}

				if (nextChar < currChar) {
					valid = false;
					break;
				}

				part2Array[currChar-48] = part2Array[currChar-48]+1;

			}

			var lastChar = numInString.charCodeAt(numInString.length-1);
			part2Array[lastChar-48] = part2Array[lastChar-48]+1;

			if (valid == true) {
				part1Answer++;

				for (x in part2Array) {
					if (x == 2) {
						part2Answer++;
						break;
					}
				}
			}
		}

		var stopStamp = Timer.stamp();

		trace("Part 1: " + part1Answer);
		trace("Part 2: " + part2Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
