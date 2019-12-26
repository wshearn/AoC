import haxe.Timer;
import sys.io.File;

class Main {
	public static function technique_cut(deck:Array<Int>, size:Int, ?rule:String):Array<Int> {
		if (size < 0) {
			size = deck.length + size;
		}
		return deck.slice(size).concat(deck.slice(0, size));
	}

	public static function technique_stack(deck:Array<Int>):Array<Int> {
		deck.reverse();

		return deck;
	}

	public static function technique_increment(deck:Array<Int>, size:Int):Array<Int> {
		var pos:Int = 0;
		var newDeck:Array<Int> = new Array<Int>();
		newDeck[deck.length - 1] = -1;

		for (x in 0...deck.length) {
			newDeck[pos] = deck[x];
			pos += size;
			while (pos > deck.length) {
				pos = pos - deck.length;
			}
		}

		return newDeck;
	}

	public static function main() {
		var stamp = Timer.stamp();

		var part1Answer = 0;

		var inputFile:String = "input";

		var raw_data = File.getContent(inputFile);
		var shuffle = raw_data.split("\n");

		// Part 1
		var numOfCards:Int = 10007;
		var deck:Array<Int> = [for (i in 0...numOfCards) i];
		for (rule in shuffle) {
			var num = rule.lastIndexOf(" ") + 1;
			if (rule == "deal into new stack") {
				deck = Main.technique_stack(deck);
			} else if (StringTools.startsWith(rule, "deal with increment")) {
				deck = Main.technique_increment(deck, Std.parseInt(rule.substring(num)));
			} else if (StringTools.startsWith(rule, "cut")) {
				deck = Main.technique_cut(deck, Std.parseInt(rule.substring(num)));
			} else {
				trace("OOPS");
			}
		}
		part1Answer = deck.lastIndexOf(2019);
		// End Part 1

		var stopStamp = Timer.stamp();
		trace("Part 1: " + part1Answer);
		trace("Time in seconds it took to run: " + (stopStamp - stamp));
	}
}
