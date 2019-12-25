import haxe.Timer;
import sys.io.File;

class Main {
	public static function main() {
		var part2Answer = 0;

		var stamp = Timer.stamp();
		var raw_data = File.getContent("input").split("\n");

		var data:Array<Map<Int, Array<Array<Int>>>> = new Array<Map<Int, Array<Array<Int>>>>();
		data[0] = new Map<Int, Array<Array<Int>>>();
		data[1] = new Map<Int, Array<Array<Int>>>();
		data[0][0] = [
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		];
		data[1][0] = [
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		];

		for (row in 0...5) {
			for (col in 0...5) {
				if (raw_data[row].charCodeAt(col) == "#".code) {
					data[0][0][row][col] = 1;
				} else {
					data[0][0][row][col] = 0;
				}
			}
		}

		var lowestKey:Int = 0;
		var highestKey:Int = 0;
		var whichData = 0;
		for (time in 0...200) {
			part2Answer = 0;

			var nextData = (whichData + 1) % 2;

			if (!data[whichData].exists(lowestKey - 1)) {
				var colCount:Int = 0;
				for (x in 0...5) {
					colCount += data[whichData][lowestKey][0][x];
					colCount += data[whichData][lowestKey][4][x];
					colCount += data[whichData][lowestKey][x][0];
					colCount += data[whichData][lowestKey][x][4];
				}

				if (colCount != 0) {
					data[0][lowestKey - 1] = [
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0]
					];
					data[1][lowestKey - 1] = [
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0]
					];

					lowestKey = lowestKey - 1;
				}
			}

			if (!data[whichData].exists(highestKey + 1)) {
				var innerCount:Int = 0;
				innerCount += data[whichData][highestKey][2][1];
				innerCount += data[whichData][highestKey][2][3];
				innerCount += data[whichData][highestKey][1][2];
				innerCount += data[whichData][highestKey][3][2];

				if (innerCount != 0) {
					data[0][highestKey + 1] = [
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0]
					];
					data[1][highestKey + 1] = [
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0]
					];
					highestKey = highestKey + 1;
				}
			}

			for (tile in data[whichData].keys()) {
				for (row in 0...5) {
					for (col in 0...5) {
						if (row == 2 && col == 2) { // Mid point is a teleporter
							continue;
						}

						var totalBugs:Int = 0;

						// Top
						if (row == 0) {
							if (data[whichData].exists(tile - 1)) {
								totalBugs += data[whichData][tile - 1][1][2];
							}
						} else if (row == 3 && col == 2) {
							if (data[whichData].exists(tile + 1)) {
								for (x in 0...5) {
									totalBugs += data[whichData][tile + 1][4][x];
								}
							}
						} else {
							totalBugs += data[whichData][tile][row - 1][col];
						}

						// Bottom
						if (row == 4) {
							if (data[whichData].exists(tile - 1)) {
								totalBugs += data[whichData][tile - 1][3][2];
							}
						} else if (row == 1 && col == 2) {
							if (data[whichData].exists(tile + 1)) {
								for (x in 0...5) {
									totalBugs += data[whichData][tile + 1][0][x];
								}
							}
						} else {
							totalBugs += data[whichData][tile][row + 1][col];
						}

						// Left
						if (col == 0) {
							if (data[whichData].exists(tile - 1)) {
								totalBugs += data[whichData][tile - 1][2][1];
							}
						} else if (row == 2 && col == 3) {
							if (data[whichData].exists(tile + 1)) {
								for (x in 0...5) {
									totalBugs += data[whichData][tile + 1][x][4];
								}
							}
						} else {
							totalBugs += data[whichData][tile][row][col - 1];
						}

						// Right
						if (col == 4) {
							if (data[whichData].exists(tile - 1)) {
								totalBugs += data[whichData][tile - 1][2][3];
							}
						} else if (row == 2 && col == 1) {
							if (data[whichData].exists(tile + 1)) {
								for (x in 0...5) {
									totalBugs += data[whichData][tile + 1][x][0];
								}
							}
						} else {
							totalBugs += data[whichData][tile][row][col + 1];
						}

						if (data[whichData][tile][row][col] != 0 && totalBugs != 1) {
							data[nextData][tile][row][col] = 0;
						} else if (data[whichData][tile][row][col] == 0 && (totalBugs == 1 || totalBugs == 2)) {
							data[nextData][tile][row][col] = 1;
						} else {
							data[nextData][tile][row][col] = data[whichData][tile][row][col];
						}

						part2Answer += data[nextData][tile][row][col];
					}
				}
			}

			whichData = nextData;
		}

		var stopStamp = Timer.stamp();

		trace("Part 2: " + part2Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
