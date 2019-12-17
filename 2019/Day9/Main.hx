import haxe.Int64;
import haxe.Int64Helper;
import haxe.Timer;
import sys.io.File;

class Main {
	public static function process(data:Array<Int64>, input:Int):Int64 {
		var finalResult:Int64 = 0;
		var pos = 0;

		var mode:Array<Int> = [0, 0, 0];
		var num:Array<Int64> = [0, 0, 0];

		var offset:Int64 = 0;

		var base:Int64 = 0;

		while (true) {
			var instruction = data[pos];

			var opcode = Int64.toInt(instruction) % 100;

			if (opcode == 99) {
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
					data[Int64.toInt(num[0])] = input;
					pos += 2;
				case 4: // Output
					finalResult = data[Int64.toInt(num[0])];
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
		var part1Answer:Int64 = 0;
		var part2Answer:Int64 = -1;

		var raw_data = File.getContent("input");
		var string_data = raw_data.split(",");
		var data:Array<Int64> = new Array<Int64>();
		for (x in 0...string_data.length) {
			data.push(Int64Helper.parseString(string_data[x]));
		}

		var stamp = Timer.stamp();

		var p1Data = data.copy();
		var p2Data = data.copy();
		part1Answer = Main.process(p1Data, 1);
		part2Answer = Main.process(p2Data, 2);
		var stopStamp = Timer.stamp();

		trace("Part 1: " + part1Answer);
		trace("Part 2: " + part2Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
