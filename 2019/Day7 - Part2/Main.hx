import haxe.Timer;
import sys.thread.Thread;
import sys.io.File;

class Main {
	public static function process():Void {
		var data:Array<Int> = Thread.readMessage(true);
		var nextThread:Thread = Thread.readMessage(true);
		var masterThread:Thread = Thread.readMessage(true);
		var finalThread:Bool = Thread.readMessage(true);
		var finalResult = 0;
		var pos = 0;
		var inputPos:Int = 0;

		while (true) {
			var instruction = data[pos];

			var opcode = Math.floor((instruction % 100));

			if (opcode == 99) {
				if (finalThread) {
					masterThread.sendMessage(finalResult);
				}
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
					var input:Int = Thread.readMessage(true);
					if (input == -99999) {
						break;
					}
					data[data[pos + 1]] = input;
					inputPos += 1;
					pos += 2;
				case 4: // Output
					finalResult = num1;
					nextThread.sendMessage(finalResult);
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
	}

	public static function main() {
		var answer = 0;

		var raw_data = File.getContent("input");
		var stamp = Timer.stamp();

		var string_data = raw_data.split(",");
		var data:Array<Int> = new Array<Int>();
		for (x in 0...string_data.length) {
			data.push(Std.parseInt(string_data[x]));
		}

		var inputs = [5, 6, 7, 8, 9];
		var running = true;
		var uniquePhase:Map<Int, Int> = new Map<Int, Int>();

		var maxRes:Int = 0;

		while (running) {
			var amp1Data = data.copy();
			var amp2Data = data.copy();
			var amp3Data = data.copy();
			var amp4Data = data.copy();
			var amp5Data = data.copy();

			var amp1T = Thread.create(Main.process);
			var amp2T = Thread.create(Main.process);
			var amp3T = Thread.create(Main.process);
			var amp4T = Thread.create(Main.process);
			var amp5T = Thread.create(Main.process);

			amp1T.sendMessage(amp1Data);
			amp2T.sendMessage(amp2Data);
			amp3T.sendMessage(amp3Data);
			amp4T.sendMessage(amp4Data);
			amp5T.sendMessage(amp5Data);

			amp1T.sendMessage(amp2T);
			amp2T.sendMessage(amp3T);
			amp3T.sendMessage(amp4T);
			amp4T.sendMessage(amp5T);
			amp5T.sendMessage(amp1T);

			amp1T.sendMessage(Thread.current());
			amp2T.sendMessage(Thread.current());
			amp3T.sendMessage(Thread.current());
			amp4T.sendMessage(Thread.current());
			amp5T.sendMessage(Thread.current());

			amp1T.sendMessage(false);
			amp2T.sendMessage(false);
			amp3T.sendMessage(false);
			amp4T.sendMessage(false);
			amp5T.sendMessage(true);

			amp1T.sendMessage(inputs[0]);
			amp2T.sendMessage(inputs[1]);
			amp3T.sendMessage(inputs[2]);
			amp4T.sendMessage(inputs[3]);
			amp5T.sendMessage(inputs[4]);

			amp1T.sendMessage(0);

			var res:Int = Thread.readMessage(true);

			amp1T.sendMessage(-99999);
			amp2T.sendMessage(-99999);
			amp3T.sendMessage(-99999);
			amp4T.sendMessage(-99999);
			amp5T.sendMessage(-99999);

			if (res > maxRes) {
				maxRes = res;
			}

			while (true) {
				uniquePhase[5] = 0;
				uniquePhase[6] = 0;
				uniquePhase[7] = 0;
				uniquePhase[8] = 0;
				uniquePhase[9] = 0;

				inputs[4] += 1;
				if (inputs[4] > 9) {
					inputs[4] = 5;
					inputs[3] += 1;
					if (inputs[3] > 9) {
						inputs[3] = 5;
						inputs[2] += 1;
						if (inputs[2] > 9) {
							inputs[2] = 5;
							inputs[1] += 1;
							if (inputs[1] > 9) {
								inputs[1] = 5;
								inputs[0] += 1;
								if (inputs[0] > 9) {
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

		answer = maxRes;

		var stopStamp = Timer.stamp();

		trace("Day 7 Part 2: " + answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
