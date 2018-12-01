import haxe.io.Eof;
import sys.io.File;

class Main {
	static function main() {
		var result:Int = 0;
		var initialResult:Int = 0;
		var initialResultFound:Bool = false;
		var dupeResult:Int = 0;
		var dupeFound:Bool = false;

		var dupe = new Map<Int, Bool>();
		while (!dupeFound) {
			var file = File.read("input");
			try {
				while (true) {
					var line = file.readLine();
					var dir = line.charAt(0);
					var num = Std.parseInt(line.substr(1, line.length));

					if (!dupeFound) dupe[result] = true;
					if (dir == '+') {
						result += num;
					} else {
						result -= num;
					}
					if (dupe.exists(result)) {
						dupeResult = result;
						dupeFound = true;
					}
				}
			}
			catch ( ex:Eof) {
				file.close();
			}
			if (!initialResultFound) {
				initialResult = result;
				initialResultFound = true;
			}

		}
		trace("Part 1 Result: " + initialResult);
		trace("Part 2 Result: " + dupeResult);
	}
}
