import sys.thread.Thread;
import haxe.Int64;
import haxe.Int64Helper;
import haxe.Timer;
import sys.io.File;

class Main {
	public static function process():Int64 {
		var finalResult:Int = 0;
		var pos = 0;

		var mode:Array<Int> = [0, 0, 0];
		var num:Array<Int64> = [0, 0, 0];

		var offset:Int64 = 0;

		var base:Int64 = 0;

		var mainThread = Thread.readMessage(true);
		mainThread.sendMessage(1);
		var data:Array<Int64> = Thread.readMessage(true);

		while (true) {
			var instruction = data[pos];

			var opcode = Int64.toInt(instruction) % 100;

			if (opcode == 99) {
				mainThread.sendMessage(-99999);
				break;
			}

			mode[0] = Math.floor((Int64.toInt(instruction) % 1000) / 100);
			mode[1] = Math.floor((Int64.toInt(instruction) % 10000) / 1000);
			mode[2] = Math.floor((Int64.toInt(instruction) % 100000) / 10000);

			for (i in 0...3) {
				offset = i + 1;

				switch (mode[i]) {
					case 1:
						num[i] = pos + offset;
					case 2:
						num[i] = data[Int64.toInt(pos + offset)] + base;
					default:
						num[i] = data[Int64.toInt(pos + offset)];
				}
			}

			switch opcode {
				case 1: // Addition
					data[Int64.toInt(num[2])] = data[Int64.toInt(num[0])] + data[Int64.toInt(num[1])];
					pos += 4;
				case 2: // Multiplication
					data[Int64.toInt(num[2])] = data[Int64.toInt(num[0])] * data[Int64.toInt(num[1])];
					pos += 4;
				case 3: // Input
					data[Int64.toInt(num[0])] = Thread.readMessage(true);
					pos += 2;
				case 4: // Output
					finalResult = Int64.toInt(data[Int64.toInt(num[0])]);
					mainThread.sendMessage(finalResult);
					Thread.readMessage(true);
					pos += 2;
				case 5: // Jump if true
					data[Int64.toInt(num[0])] != 0 ? pos = Int64.toInt(data[Int64.toInt(num[1])]) : pos += 3;
				case 6: // Jump if false
					data[Int64.toInt(num[0])] == 0 ? pos = Int64.toInt(data[Int64.toInt(num[1])]) : pos += 3;
				case 7: // Less than
					data[Int64.toInt(num[0])] < data[Int64.toInt(num[1])] ? data[Int64.toInt(num[2])] = 1 : data[Int64.toInt(num[2])] = 0;
					pos += 4;
				case 8: // Equals to
					data[Int64.toInt(num[0])] == data[Int64.toInt(num[1])] ? data[Int64.toInt(num[2])] = 1 : data[Int64.toInt(num[2])] = 0;
					pos += 4;
				case 9:
					base += data[Int64.toInt(num[0])];
					pos += 2;
			}
		}

		return finalResult;
	}

	public static function main() {
		var part1Answer:Int = 0;
		var part2Answer:Int = -1;

		var raw_data = File.getContent("input");
		var string_data = raw_data.split(",");
		var data:Array<Int64> = new Array<Int64>();
		for (x in 0...string_data.length) {
			data.push(Int64Helper.parseString(string_data[x]));
		}

		var stamp = Timer.stamp();

		var p1Data = data.copy();
		var p1Thread = Thread.create(Main.process);
		p1Thread.sendMessage(Thread.current());
		Thread.readMessage(true); // Just to delay sending the data
		p1Thread.sendMessage(p1Data);
		var message:Int = 0;

		var image:Array<Array<Int>> = new Array<Array<Int>>();
		image.push(new Array<Int>());

		var running:Bool = true;
		while (running) {
			message = Thread.readMessage(true);
			p1Thread.sendMessage(1);
			if (message == -99999) {
				break;
			}

			if (message == 10) {
				image.push(new Array<Int>());
				continue;
			}
			image[image.length - 1].push(message);
		}

		image.pop(); // Had an empty array at the end

		for (y in 0...image.length) {
			for (x in 0...image[y].length) {
				var validTop:Bool = false;
				var validBottom:Bool = false;
				var validLeft:Bool = false;
				var validRight:Bool = false;

				if (image[y][x] == 46) {
					continue;
				}

				if (y == 0) {
					if (image[image.length - 1][x] != 46) {
						validTop = true;
					}
					if (image[y + 1][x] != 46) {
						validBottom = true;
					}
				} else {
					if (image[y - 1][x] != 46) {
						validTop = true;
					}

					if (y == image.length - 1) {
						if (image[0][x] != 46) {
							validBottom = true;
						}
					} else if (image[y + 1][x] != 46) {
						validBottom = true;
					}
				}

				if (x == 0) {
					if (image[y][image[y].length - 1] != 46) {
						validLeft = true;
					}
					if (image[y][x + 1] != 46) {
						validRight = true;
					}
				} else {
					if (image[y][x - 1] != 46) {
						validLeft = true;
					}

					if (x == image[y].length - 1) {
						if (image[y][0] != 46) {
							validRight = true;
						}
					} else {
						if (image[y][x + 1] != 46) {
							validRight = true;
						}
					}
				}

				if (validTop && validLeft && validBottom && validRight) {
					part1Answer += y * x;
				}
			}
		}

		for (y in image) {
			for (char in y) {
				Sys.print(String.fromCharCode(char));
			}
			Sys.println("");
		}

		var stopStamp = Timer.stamp();
		Sys.println('');
		trace("Part 1: " + part1Answer);
		trace("Part 2: " + part2Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
