import haxe.Timer;
import sys.io.File;

class Main {
	static function main() {
        
        var stamp = Timer.stamp();
        var data = File.getContent("input").split('\n');
        data.remove("");
        var fabric:Array<Array<Int>> = [ for (x in 0...1000) [ for (y in 0...1000) 0 ]];
        var used = 0;
        var goodSquares = new List<Int>();
        var singleSquare = "";
        for (square in data) {
            var goodSquare:Bool = true;
            var squareSplit = square.split(' ');
            var cords = squareSplit[2].split(',');
            cords[1] = cords[1].substring(0, cords[1].length-1);
            
            var x = Std.parseInt(cords[0]);
            var y = Std.parseInt(cords[1]);
            
            
            var size = squareSplit[3].split('x');
            var x2 = x+Std.parseInt(size[0]);
            var y2 = y+Std.parseInt(size[1]);
            
            for (x3 in x...x2) {
                for (y3 in y...y2) {
                    fabric[x3][y3]++;
                    if (fabric[x3][y3] == 2) {
                        used++;
                    }
                    if (fabric[x3][y3] > 1) {
                        goodSquare = false;
                    }
                }
            }
            if (goodSquare) {
                goodSquares.add(Std.parseInt(squareSplit[0].substring(1, squareSplit[0].length)));
            }
        }
        
        for (gSquare in goodSquares) {
            var square = data[gSquare-1];
            var squareSplit = square.split(' ');
            var cords = squareSplit[2].split(',');
            cords[1] = cords[1].substring(0, cords[1].length-1);
            
            var x = Std.parseInt(cords[0]);
            var y = Std.parseInt(cords[1]);
            var size = squareSplit[3].split('x');
            var x2 = x+Std.parseInt(size[0]);
            var y2 = y+Std.parseInt(size[1]);
            var goodSquare:Bool = true;
            for (x3 in x...x2) {
                for (y3 in y...y2) {
                    if (fabric[x3][y3] > 1) {
                        goodSquare = false;
                    }
                }
            }
            if (goodSquare) {
                singleSquare = squareSplit[0].substring(1, squareSplit[0].length);
                break;
            }
            
        }
        
        var stopStamp = Timer.stamp();
        
        trace("Part 1 Result: " + used);
        trace("Part 2 Result: " + singleSquare);
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}
