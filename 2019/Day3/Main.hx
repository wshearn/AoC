import haxe.Timer;
import sys.io.File;

class Point {
	public var x:Int;
	public var y:Int;

	public function new(x, y) {
		this.x = x;
		this.y = y;
	}
}

class Main {
	public static function looper(wire:Array<String>):Map<String, Int> {
		var path:Map<String, Int> = new Map<String, Int>();
		var position = new Point(0, 0);
		var totalSteps = 0;

		for (item in wire) {
			var dir = item.substr(0, 1);
			var steps = Std.parseInt(item.substr(1));

			switch dir {
				case "R":
					for (x in 0...steps) {
						var key = position.x + "x" + position.y;
						if (!path.exists(key)) {
							path[key] = totalSteps;
						}
						totalSteps = totalSteps + 1;
						position.x = position.x + 1;
					}
				case "L":
					for (x in 0...steps) {
						var key = position.x + "x" + position.y;
						if (!path.exists(key)) {
							path[key] = totalSteps;
						}
						totalSteps = totalSteps + 1;
						position.x = position.x - 1;
					}
				case "D":
					for (x in 0...steps) {
						var key = position.x + "x" + position.y;
						if (!path.exists(key)) {
							path[key] = totalSteps;
						}
						totalSteps = totalSteps + 1;
						position.y = position.y - 1;
					}
				case "U":
					for (x in 0...steps) {
						var key = position.x + "x" + position.y;
						if (!path.exists(key)) {
							path[key] = totalSteps;
						}
						totalSteps = totalSteps + 1;
						position.y = position.y + 1;
					}
			}
		}

		return path;
	}

	public static function main() {
		var part1Answer = 0x3FFFFFFF;
		var part2Answer = 0x3FFFFFFF;

		var raw_data = File.getContent("input").split("\n");
		var wireOne = raw_data[0].split(",");
		var wireTwo = raw_data[1].split(",");

		var stamp = Timer.stamp();

		var pathsOne:Map<String, Int> = Main.looper(wireOne);
		var pathsTwo:Map<String, Int> = Main.looper(wireTwo);

		// Don't count overlap on 0x0
		pathsTwo.remove("0x0");

		var crossedPaths:Array<Point> = new Array<Point>();
		for (path in pathsOne.keys()) {
			if (pathsTwo.exists(path)) {
				var sPath = path.split("x");

				crossedPaths.push(new Point(Std.parseInt(sPath[0]), Std.parseInt(sPath[1])));

				if (pathsOne[path] + pathsTwo[path] < part2Answer) {
					part2Answer = pathsOne[path] + pathsTwo[path];
				}
			}
		}

		for (cPath in crossedPaths) {
			var distX = cPath.x;
			var distY = cPath.y;
			if (distY < 0) {
				distY = Math.round(Math.abs(distY));
			}
			if (distX < 0) {
				distX = Math.round(Math.abs(distX));
			}
			var dist = distY + distX;
			if (dist < part1Answer) {
				part1Answer = dist;
			}
		}

		var stopStamp = Timer.stamp();
		trace("Part 1: " + part1Answer);
		trace("Part 2: " + part2Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
