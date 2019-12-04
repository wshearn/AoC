import haxe.Timer;

class Main {
	public static function main() {
		var part1Answer = 0;
		var part2Answer = 0;

		var input = [109165, 576723];

		var stamp = Timer.stamp();

		for (x in input[0]...input[1]) {
			var numArray = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

			var num1 = Math.floor((x % 1000000) / 100000);
			var num2 = Math.floor((x % 100000) / 10000);
			var num3 = Math.floor((x % 10000) / 1000);
			var num4 = Math.floor((x % 1000) / 100);
			var num5 = Math.floor((x % 100) / 10);
			var num6 = Math.floor((x % 10) / 1);

			if (num1 > num2 || num2 > num3 || num3 > num4 || num4 > num5 || num5 > num6) {
				continue;
			}

			numArray[num1]++;
			numArray[num2]++;
			numArray[num3]++;
			numArray[num4]++;
			numArray[num5]++;
			numArray[num6]++;

			var validP1 = false;
			var validP2 = false;
			for (x in numArray) {
				if (x >= 2) {
					validP1 = true;
				}

				if (x == 2) {
					validP2 = true;
				}
			}

			if (validP1 == true) {
				part1Answer++;
			}

			if (validP2 == true) {
				part2Answer++;
			}
		}

		var stopStamp = Timer.stamp();

		trace("Part 1: " + part1Answer);
		trace("Part 2: " + part2Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
