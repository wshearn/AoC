import haxe.Timer;
import sys.io.File;

class Main {
	static function main() {

		var stamp = Timer.stamp();
		var data = File.getContent("input").split('\n');
		data.remove("");
		while (true) {
			break;
		}
		var stopStamp = Timer.stamp();

		trace("Part 1 Result: ");
		trace("Part 2 Result: ");
		trace("Time in seconds it took to run: " + (stopStamp-stamp));
	}
}
