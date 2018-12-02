import haxe.Timer;
import sys.io.File;

class Main {
	static function main() {
		var loops = 0;
		var result:Int = 0;
		var initialResult:Int = 0;
		var initialResultFound:Bool = false;
		var dupeResult:Int = 0;
		var dupeFound:Bool = false;
		var dupe = new Map<Int, Bool>();
		
		var stamp = Timer.stamp();
		var data = File.getContent("input").split('\n');
		data.remove("");
		while (true) {
			loops++;
			for (change in data) {
				var dir = change.charAt(0);
				var num = Std.parseInt(change.substr(1, change.length));
                
				if (!dupeFound) dupe[result] = true;
                
				if (dir == '+') {
					result += num;
				} else {
					result -= num;
				}
                
				if (dupeFound == false && dupe.exists(result)) {
					dupeResult = result;
					dupeFound = true;
				}
			}
			if (!initialResultFound) {
				initialResult = result;
				initialResultFound = true;
			}
            
			if (initialResultFound && dupeFound) {
				break;
			}
		}
		var stopStamp = Timer.stamp();
        
		trace("Part 1 Result: " + initialResult);
		trace("Part 2 Result: " + dupeResult);
		trace("Part 2 took " + loops + " loops");
		trace("Time in seconds it took to run: " + (stopStamp-stamp));
	}
}
