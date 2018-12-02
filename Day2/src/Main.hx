import haxe.Timer;
import sys.io.File;

class Main {
	static function main() {
		var two = 0;
		var three = 0;

		var data = File.getContent("input").split('\n');
		data.remove("");

		var p1stamp = Timer.stamp();
		for (id in data) {
			var labelHash = new Map<String, Int>();
			var idSplit = id.split("");
			for (char in idSplit) {
				if (!labelHash.exists(char)) {
					labelHash[char] = 1;
				} else {
					labelHash[char] += 1;
				}
			}

			var twoUsed:Bool = false;
			var threeUsed:Bool = false;
			for (char in labelHash.keys()) {
				if (!twoUsed && labelHash[char] == 2) {
					two++;
					twoUsed = true;
				} else if (!threeUsed && labelHash[char] == 3) {
					three++;
					threeUsed = true;
				}

				if (threeUsed && twoUsed) {
					break;
				}
			}
		}
		var p1stopStamp = Timer.stamp();

		var p2stamp = Timer.stamp();
		var currentMatch = {
			"key": "",
			"diff": 9999
		}

		for (x in 0...data.length) {
			var derp:Int = x+1;
			for (y in derp...data.length) {
				var diff:Int = 0;
				var same:String = "";
				for (z in 0...data[x].length) {
					if (data[x].charAt(z) != data[y].charAt(z)) {
						diff += 1;
					} else {
						same = same + data[x].charAt(z);
					}
				}
				if (currentMatch.diff > diff) {
					currentMatch.diff = diff;
					currentMatch.key = same;
				}
			}
		}

		var p2stopStamp = Timer.stamp();
	
		trace("Checksum: " + (two * three));
		trace("Same key: " + currentMatch.key);
		trace("Time in seconds it took to run part1: " + (p1stopStamp-p1stamp));
		trace("Time in seconds it took to run part2: " + (p2stopStamp-p2stamp));
	}
}
