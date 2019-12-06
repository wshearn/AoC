import haxe.Timer;
import sys.io.File;

class StarMap {
	var orbits:Map<String, Array<String>>;

	public function addOrbit(left:String, right:String) {
		if (!orbits.exists(left)) {
			orbits[left] = [right];
		} else {
			orbits[left].push(right);
		}
	}

	public function new() {
		orbits = new Map<String, Array<String>>();
	}

	public function countOrbits(name:String, chainLength:Int = 0):Int {
		if (!orbits.exists(name)) {
			return chainLength;
		}

		var result = chainLength;

		chainLength += 1;
		for (orbit in orbits[name]) {
			result += countOrbits(orbit, chainLength);
		}

		return result;
	}

	function findOrbit(name:Array<String>, start:String = "COM"):Array<String> {
		var result = new Array<String>();

        if (start == name[0]) {
            result.push(start);
            return result;
        }

        if (!orbits.exists(start)) {
            return null;
        }

        for (orbit in orbits[start]) {
            var found = findOrbit(name, orbit);
            if (found != null) {
                found.push(start);
                return found;
            }
        }

		return null;
	}

	public function getFromCom(name:String):Array<String> {
		var result:Array<String> = new Array<String>();

		// YOU should go YOU->K->J->E->D->C->B->COM
		var currentSearch = [name];
        result = findOrbit(currentSearch);

		if (result.length != 0) {
			result.reverse(); // Flip it so index 0 is COM
		}

		return result;
	}

	public function findDistFrom(placeA:String, placeB:String):Int {
		var result = 0;

		var placeAToCom = getFromCom(placeA);
		var placeBToCom = getFromCom(placeB);

		var len = 0;
		if (placeAToCom.length < placeBToCom.length) {
			len = placeAToCom.length;
		} else {
			len = placeBToCom.length;
		}

		var endSame = 0;
		for (x in 0...len) {
			if (placeAToCom[x] == placeBToCom[x]) {
				endSame = x;
			} else {
				endSame += 1;
				break;
			}
		}

		result += placeAToCom.length - endSame - 1;
		result += placeBToCom.length - endSame - 1;
		return result;
	}
}

class Main {
	public static function main() {
		var part1Answer = 0;
		var part2Answer = 0;

		var raw_data = File.getContent("input");

		var stamp = Timer.stamp();

		var starMap = new StarMap();

		for (sorbit in raw_data.split("\n")) {
			var orbit = sorbit.split(")");
			starMap.addOrbit(orbit[0], StringTools.rtrim(orbit[1]));
		}

		part1Answer = starMap.countOrbits("COM");
		part2Answer = starMap.findDistFrom("YOU", "SAN");

		var stopStamp = Timer.stamp();

		trace("Part 1: " + part1Answer);
		trace("Part 2: " + part2Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
