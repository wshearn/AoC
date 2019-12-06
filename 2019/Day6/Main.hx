import haxe.Timer;
import sys.io.File;

class GalaticObject {
	public var parent:GalaticObject;
	public var children:Array<GalaticObject>;
	public var name:String;

	public function new() {}
}

class StarMap {
	var orbits:Map<String, GalaticObject>;

	public function addOrbit(left:String, right:String) {
		if (!orbits.exists(left)) {
			var newParent:GalaticObject = new GalaticObject();
			newParent.parent = null;
			newParent.children = new Array<GalaticObject>();
			newParent.name = left;

			orbits[left] = newParent;
		}

		var child:GalaticObject;
		if (!orbits.exists(right)) {
			child = new GalaticObject();
			child.children = new Array<GalaticObject>();
		} else {
			child = orbits[right];
		}
		child.parent = orbits[left];
		child.name = right;
		orbits[left].children.push(child);
		orbits[right] = child;
	}

	public function new() {
		orbits = new Map<String, GalaticObject>();
	}

	public function countOrbits(?gObject:GalaticObject, chainLength:Int = 0):Int {
		if (gObject == null) {
			gObject = orbits["COM"];
		}

		var result = chainLength;

		if (gObject.children.length == 0) {
			return chainLength;
		} else {
			chainLength += 1;
			for (child in gObject.children) {
				result += countOrbits(child, chainLength);
			}
		}

		return result;
	}

	public function findDistFrom(placeA:String, placeB:String):Int {
		var result = 0;

		var marker = orbits[placeA];
		var placeAToCom = new Array<String>();
		while (marker.parent != null) {
			placeAToCom.push(marker.name);
			marker = marker.parent;
		}

		var placeBToCom = new Array<String>();
		marker = orbits[placeB];
		while (marker.parent != null) {
			placeBToCom.push(marker.name);
			marker = marker.parent;
		}

		while (placeAToCom[placeAToCom.length - 1] == placeBToCom[placeBToCom.length - 1]) {
			placeAToCom.pop();
			placeBToCom.pop();
		}

		result += placeAToCom.length - 1;
		result += placeBToCom.length - 1;
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

		part1Answer = starMap.countOrbits();
		part2Answer = starMap.findDistFrom("YOU", "SAN");

		var stopStamp = Timer.stamp();

		trace("Part 1: " + part1Answer);
		trace("Part 2: " + part2Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
