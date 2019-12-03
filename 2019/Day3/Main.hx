import haxe.Timer;
import sys.io.File;

class Point {
	public var x:Int;
	public var y:Int;

	public function new(x, y) {
		this.x = x;
		this.y = y;
	}

	public function toString() {
		return "Point(" + x + "," + y + ")";
	}
}

abstract AbstractPoint(Point) from Point to Point {
	@:op(A > B) public function greaterThan(b:Point):Bool {
		if (this.x == b.x) {
			return (this.y > b.y);
		}
		if (this.y == b.y) {
			return (this.x > b.x);
		}

		return (this.x + this.y) > (b.x + b.y);
	}

	@:op(A < B) public function lessThan(b:Point):Bool {
		if (this.x == b.x) {
			return (this.y < b.y);
		}
		if (this.y == b.y) {
			return (this.x < b.x);
		}

		return (this.x + this.y) < (b.x + b.y);
	}

	@:op(A == B) public function equalToo(b:Point):Bool {
		return (this.x == b.x && this.y == b.y);
	}
}

class Main {
	public static function main() {
		var part1Answer = 999999;
		var part2Answer = 999999;

		var raw_data = File.getContent("input").split("\n");
		var wireOne = raw_data[0].split(",");
		var wireTwo = raw_data[1].split(",");

		var stamp = Timer.stamp();

		var pathsOne:Map<String, Int> = new Map<String, Int>();
		var pathsTwo:Map<String, Int> = new Map<String, Int>();

		var position = new Point(0, 0);
		var totalSteps = 0;
		for (item in wireOne) {
			var dir = item.substr(0, 1);
			var steps = Std.parseInt(item.substr(1));

			switch dir {
				case "R":
					for (x in 0...steps) {
                        var key = position.x + "x" + position.y;
                        if (!pathsOne.exists(key)) {
                            pathsOne[key] = totalSteps;
                        }
                        totalSteps = totalSteps + 1;
						position.x = position.x + 1;
					}
				case "L":
					for (x in 0...steps) {
                        var key = position.x + "x" + position.y;
                        if (!pathsOne.exists(key)) {
                            pathsOne[key] = totalSteps;
                        }
                        totalSteps = totalSteps + 1;
						position.x = position.x - 1;
					}
				case "D":
					for (x in 0...steps) {
                        var key = position.x + "x" + position.y;
                        if (!pathsOne.exists(key)) {
                            pathsOne[key] = totalSteps;
                        }
                        totalSteps = totalSteps + 1;
						position.y = position.y - 1;
					}
				case "U":
					for (x in 0...steps) {
                        var key = position.x + "x" + position.y;
                        if (!pathsOne.exists(key)) {
                            pathsOne[key] = totalSteps;
                        }
                        totalSteps = totalSteps + 1;
						position.y = position.y + 1;
					}
			}
		}

		var position = new Point(0, 0);
		var totalSteps = 0;
		for (item in wireTwo) {
			var dir = item.substr(0, 1);
			var steps = Std.parseInt(item.substr(1));

			switch dir {
				case "R":
					for (x in 0...steps) {
						var key = position.x + "x" + position.y;
						if (!pathsTwo.exists(key)) {
							pathsTwo[key] = totalSteps;
						}
                        totalSteps = totalSteps + 1;
						position.x = position.x + 1;
					}
				case "L":
					for (x in 0...steps) {
						var key = position.x + "x" + position.y;
						if (!pathsTwo.exists(key)) {
							pathsTwo[key] = totalSteps;
						}
                        totalSteps = totalSteps + 1;
						position.x = position.x - 1;
					}
				case "D":
					for (x in 0...steps) {
						var key = position.x + "x" + position.y;
						if (!pathsTwo.exists(key)) {
							pathsTwo[key] = totalSteps;
						}
                        totalSteps = totalSteps + 1;
						position.y = position.y - 1;
					}
				case "U":
					for (x in 0...steps) {
						var key = position.x + "x" + position.y;
						if (!pathsTwo.exists(key)) {
							pathsTwo[key] = totalSteps;
						}
                        totalSteps = totalSteps + 1;
						position.y = position.y + 1;
					}
			}
		}
		var crossedPaths:Array<Point> = new Array<Point>();

		pathsTwo.remove("0x0");
		for (path in pathsOne.keys()) {
			if (pathsTwo.exists(path)) {
				var sPath = path.split("x");

				crossedPaths.push(new Point(Std.parseInt(sPath[0]), Std.parseInt(sPath[1])));

				if (pathsOne[path] + pathsTwo[path] < part2Answer) {
					part2Answer = pathsOne[path] + pathsTwo[path];
				}
			}
		}

		var maxDist:Int = 9999;
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
