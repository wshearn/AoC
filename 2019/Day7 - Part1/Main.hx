import haxe.Timer;
import sys.io.File;

class Main {
	public static function process(data:Array<Int>, input:Array<Int>):Int {
		var finalResult = 0;
		var pos = 0;
        var inputPos:Int = 0;

		while (true) {
			var instruction = data[pos];

			var opcode = Math.floor((instruction % 100));

			if (opcode == 99) {
				break;
			}

			var num1Ins = Math.floor((instruction % 1000) / 100);
			var num2Ins = Math.floor((instruction % 10000) / 1000);

			Assertion.assert(num1Ins == 0 || num1Ins == 1);
			Assertion.assert(num2Ins == 0 || num2Ins == 1);

			var num1:Int = 0;
			var num2:Int = 0;

			if (num1Ins == 0) {
				num1 = data[data[pos + 1]];
			} else if (num1Ins == 1) {
				num1 = data[pos + 1];
			}

			if (num2Ins == 0) {
				num2 = data[data[pos + 2]];
			} else if (num2Ins == 1) {
				num2 = data[pos + 2];
			}

			switch opcode {
				case 1: // Addition
					data[data[pos + 3]] = num1 + num2;
					pos += 4;
				case 2: // Multiplication
					data[data[pos + 3]] = num1 * num2;
					pos += 4;
				case 3: // Input
					data[data[pos + 1]] = input[inputPos];
                    inputPos += 1;
                    if (inputPos == input.length) {
                        inputPos = 0;
                    }
					pos += 2;
				case 4: // Output
					finalResult = num1;
					if (data[pos + 2] != 99) {
						Assertion.assert(finalResult == 0);
					}
					pos += 2;
				case 5: // Jump if true
					if (num1 != 0) {
						pos = num2;
					} else {
						pos += 3;
					}
				case 6: // Jump if false
					if (num1 == 0) {
						pos = num2;
					} else {
						pos += 3;
					}
				case 7: // Less than
					if (num1 < num2) {
						data[data[pos + 3]] = 1;
					} else {
						data[data[pos + 3]] = 0;
					}
					pos += 4;
				case 8: // Equals to
					if (num1 == num2) {
						data[data[pos + 3]] = 1;
					} else {
						data[data[pos + 3]] = 0;
					}
					pos += 4;
			}
		}

		return finalResult;
	}

	public static function main() {
		var part1Answer = 0;

		var raw_data = File.getContent("input");
        var stamp = Timer.stamp();

		var string_data = raw_data.split(",");
		var data:Array<Int> = new Array<Int>();
		for (x in 0...string_data.length) {
			data.push(Std.parseInt(string_data[x]));
		}

        var maxRes = 0;

        var inputs = [0,1,2,3,4];
        var running = true;
        var uniquePhase:Map<Int, Int> = new Map<Int, Int>();

        while (running) {
            var amp1Data = data.copy();
            var amp1 = Main.process(amp1Data, [inputs[0], 0]);
            var amp2Data = data.copy();
            var amp2 = Main.process(amp2Data, [inputs[1], amp1]);
            var amp3Data = data.copy();
            var amp3 = Main.process(amp3Data, [inputs[2], amp2]);
            var amp4Data = data.copy();
            var amp4 = Main.process(amp4Data, [inputs[3], amp3]);
            var amp5Data = data.copy();
            var amp5 = Main.process(amp5Data, [inputs[4], amp4]);

            if (amp5 > maxRes) {
                maxRes = amp5;
                part1Answer = amp5;
            }

            while (true) {
                uniquePhase[0] = 0;
                uniquePhase[1] = 0;
                uniquePhase[2] = 0;
                uniquePhase[3] = 0;
                uniquePhase[4] = 0;

                inputs[4] += 1;
                if (inputs[4] > 4) {
                    inputs[4] = 0;
                    inputs[3] += 1;
                    if (inputs[3] > 4) {
                        inputs[3] = 0;
                        inputs[2] += 1;
                        if (inputs[2] > 4) {
                            inputs[2] = 0;
                            inputs[1] += 1;
                            if (inputs[1] > 4) {
                                inputs[1] = 0;
                                inputs[0] += 1;
                                if (inputs[0] > 4) {
                                    running = false;
                                    break;
                                }
                            }
                        }
                    }
                }

                uniquePhase[inputs[0]] += 1;
                uniquePhase[inputs[1]] += 1;
                uniquePhase[inputs[2]] += 1;
                uniquePhase[inputs[3]] += 1;
                uniquePhase[inputs[4]] += 1;

                var valid = true;
                for (x in uniquePhase) {
                    if (x > 1) {
                        valid = false;
                    }
                }

                if (valid) {
                    break;
                }
            }
        }

		var stopStamp = Timer.stamp();

		trace("Day 7 Part 1: " + part1Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
