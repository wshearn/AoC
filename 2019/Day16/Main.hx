import sys.FileSystem;
import haxe.Timer;
import sys.io.File;

class Main {
	public static function main() {
		var part1Answer = "";
		var part2Answer = 0;

		var inputFile:String = "input";
		if (Sys.args().length > 0 && FileSystem.exists(Sys.args()[0])) {
			inputFile = Sys.args()[0];
		}

		var raw_data = File.getContent(inputFile);

		var data:Array<Array<Int>> = new Array<Array<Int>>();
		data[0] = new Array<Int>();
		data[1] = new Array<Int>();

		var stamp = Timer.stamp();

		var pattern:Array<Int> = [0, 1, 0, -1];

		var stopStamp = Timer.stamp();

		for (num in 0...raw_data.length) {
			data[0].push(raw_data.charCodeAt(num) - "0".code);
			data[1].push(0);
		}

		var which = 0;
		for (loop in 0...100) {
			var modding = (which + 1) % 2;
			for (x in 0...data[which].length) {
				var tmpPattern = new Array<Int>();

				for (base in pattern) {
					for (_ in 0...x+1) {
						tmpPattern.push(base);
					}
				}
				var loopPattern = tmpPattern.slice(1, tmpPattern.length).concat(tmpPattern.slice(0, 1));

				var newSignal = 0;
				var pos = 0;

				for (num in data[which]) {
					newSignal += (num * loopPattern[pos]);
					pos += 1;
					if (pos >= loopPattern.length) {
						pos = 0;
					}
				}

				data[modding][x] = Math.floor(Math.abs(newSignal % 10));
			}
			which = modding;
		}

		part1Answer = data[which].slice(0, 8).join("");

		trace("Part 1: " + part1Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
