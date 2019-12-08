import haxe.Timer;
import sys.io.File;

class Main {
	public static function main() {
		var part1Answer = 0;
		var part2Answer = "";

		var raw_data = File.getContent("input");

		var stamp = Timer.stamp();

		var pos:Int = 0;
		var width:Int = 25;
		var height:Int = 6;
		var leastZero:Int = (width * height + 1);

		var numOfLayers:Int = Math.floor(raw_data.length / (width * height));
		var finalImage:Array<Array<Int>> = [ for (x in 0...height) [ for (y in 0...width) 2 ]];

		for (x in 0...numOfLayers) {
			var layerBits = [0, 0, 0];

			part2Answer = "";
			for (h in 0...height) {
				part2Answer += "\n";
				for (w in 0...width) {
					var imageData = raw_data.charCodeAt(pos) - 48;
					layerBits[imageData]++;

					if (finalImage[h][w] == 2 && imageData != 2) {
						finalImage[h][w] = imageData;
					}

					if (x == numOfLayers - 1) {
						Assertion.assert(finalImage[h][w] != 2);
						switch finalImage[h][w] {
							case 0:
								part2Answer += " ";
							case 1:
								part2Answer += "#";
						}
					}

					pos += 1;
				}
			}
			if (layerBits[0] < leastZero) {
				leastZero = layerBits[0];
				part1Answer = layerBits[1] * layerBits[2];
			}
		}

		var stopStamp = Timer.stamp();

		trace("Part 1: " + part1Answer);
		trace("Part 2: " + part2Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
