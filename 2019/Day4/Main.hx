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

			var myMap:Map<Int, Int> = new Map<Int, Int>();

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

				if (myMap.exists(currChar)) {
					myMap[currChar] = myMap[currChar] + 1;
				} else {
					myMap[currChar] = 1;
				}
			}

			var lastChar = numInString.charCodeAt(numInString.length-1);
			if (myMap.exists(lastChar)) {
				myMap[lastChar] = myMap[lastChar] + 1;
			} else {
				myMap[lastChar] = 1;
			}

			if (valid == true) {
				part1Answer++;

				for (x in myMap) {
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
