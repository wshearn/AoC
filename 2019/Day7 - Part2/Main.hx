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
		var threads:Array<Thread> = new Array<Thread>();
		while (running) {
			threads = new Array<Thread>();
			for (x in 0...inputs.length) {
				var tData = data.copy();
				threads.push(Thread.create(Main.process));
				threads[threads.length-1].sendMessage(tData);
			}

			for (x in 0...threads.length) {
				var nextThread:Thread;
				var finalThread:Bool = (x == 4);
				if (x < 4) {
					nextThread = threads[x+1];
				} else {
					nextThread = threads[0];
				}
				threads[x].sendMessage(nextThread);
				threads[x].sendMessage(Thread.current());
				threads[x].sendMessage(finalThread);
				threads[x].sendMessage(inputs[x]);
			}

			threads[0].sendMessage(0);

			var res:Int = Thread.readMessage(true);

			for (pThread in threads) {
				pThread.sendMessage(-99999);
			}

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
