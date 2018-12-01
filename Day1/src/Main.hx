import haxe.io.Eof;
import sys.io.File;

class Main {
	static function main() {
		var result:Int = 0;
		var file = File.read("input");
		try {
			while (true) {
				var line = file.readLine();
				var dir = line.charAt(0);
				var num = Std.parseInt(line.substr(1, line.length));
				
				if (dir == '+') {
					result += num;
				} else {
					result -= num;
				}
			}
		}
		catch ( ex:Eof) {
			trace(result);
		}	
	}
}
