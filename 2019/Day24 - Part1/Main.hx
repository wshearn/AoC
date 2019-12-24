import sys.FileSystem;
import haxe.Timer;
import sys.io.File;

class Main {
	public static function main() {
		var part1Answer = 0;

		var stamp = Timer.stamp();
		var raw_data = File.getContent("input").split("\n");

		var data:Array<Array<Int>> = [ for (x in 0...5) [ for (y in 0...5) 0 ]];
		var results:Map<Int, Bool> = new Map<Int, Bool>();
		var biodivers = 0;

		for (line in 0...5) {
			for (char in 0...5) {
				if (raw_data[line].charAt(char) == "#") {
					data[line][char] = Math.floor(Math.pow(2, (line*5)+(char)));
				} else {
					data[line][char] = 0;
				}
				biodivers += data[line][char];
			}
		}
		results[biodivers] = true;

		while (true) {
			var newData:Array<Array<Int>> = [ for (x in 0...5) [ for (y in 0...5) 0 ]];
			biodivers = 0;

			for (row in 0...5) {
				for (col in 0...5) {
					var totalBugs:Int = 0;
					if (row > 0) {
						if (data[row-1][col] > 0) {
							totalBugs++;
						}
					}
					if (row < 4) {
						if (data[row+1][col] > 0) {
							totalBugs++;
						}
					}
					if (col > 0) {
						if (data[row][col-1] != 0) {
							totalBugs++;
						}
					}

					if (col < 4) {
						if (data[row][col+1] != 0) {
							totalBugs++;
						}
					}

					if (data[row][col] != 0 && totalBugs != 1) {
						newData[row][col] = 0;
					} else if (data[row][col] == 0 && (totalBugs == 1 || totalBugs == 2)) {
						newData[row][col] = Math.floor(Math.pow(2, (row*5)+(col)));
					} else {
						newData[row][col] = data[row][col];
					}
					biodivers += newData[row][col];
				}
			}

			if (results.exists(biodivers) && results[biodivers] == true) {
				part1Answer = biodivers;
				break;
			} else {
				results[biodivers] = true;
				data = newData;
			}
		}

		var stopStamp = Timer.stamp();

		trace("Part 1: " + part1Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
