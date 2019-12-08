import lime.graphics.Image;
import sys.io.FileOutput;
import sys.FileSystem;
import haxe.Timer;
import sys.io.File;

class Main {
	public static function main() {
		var part1Answer = 0;

		var inputFile:String = "input";
		if (Sys.args().length > 0 && FileSystem.exists(Sys.args()[0])) {
			inputFile = Sys.args()[0];
		}

		var raw_data = File.getContent(inputFile);

		var stamp = Timer.stamp();

		var width:Int = 25;
		var height:Int = 6;

		if (inputFile != "input") {
			width = 2;
			height = 2;
		}

		var numOfLayers = Math.floor(raw_data.length/(width*height));

		var layers:Array<Map<Int, Int>> = new Array<Map<Int, Int>>();
		var finalImage:Array<Array<Int>> = new Array<Array<Int>>();
		for (w in 0...width) {
			finalImage.push(new Array<Int>());
			for (h in 0...height) {
				finalImage[w][h] = 2;
			}
		}
		var pos = 0;
		var leastZero = [0, (width*height+1)];
		var image:Image = new Image(null, 0, 0, width, height, 0xEEEEEE, DATA);
		image.fillRect(new lime.math.Rectangle(0, 0, width, height), 0xEEEEEE);

		for (layer in 0...numOfLayers) {
			layers[layer] = new Map<Int, Int>();
			var layerZero = 0;
			for (w in 0...width) {
				for (h in 0...height) {
					var imageData = Std.parseInt(raw_data.charAt(pos));
					if (imageData == 0) {
						layerZero++;
					}

					if (finalImage[w][h] == 2 && imageData != 2) {
						finalImage[w][h] = imageData;

						if (imageData == 0) {
							image.setPixel(w, h, 0x111111);
						} else {
							image.setPixel(w, h, 0xEEEEEE);
						}
					}

					if (!layers[layer].exists(imageData)) {
						layers[layer][imageData] = 1;
					} else {
						layers[layer][imageData] += 1;
 					}

					pos += 1;
				}
			}
			if (layerZero < leastZero[1]) {
				leastZero[0] = layer;
				leastZero[1] = layerZero;
			}
		}

		part1Answer = layers[leastZero[0]][1] * layers[leastZero[0]][2];

		var fout:FileOutput = sys.io.File.write("part2.bmp", true);
		fout.writeString(image.encode(BMP).toString());
		fout.close();

		var stopStamp = Timer.stamp();

		trace("Part 1: " + part1Answer);
		trace("Part 2: see part2.bmp");
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
