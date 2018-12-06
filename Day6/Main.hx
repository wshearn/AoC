import haxe.Timer;
import sys.io.File;

class Main {
    static var dataFile = "input.sample";
    //static var dataFile = "input";
    static function main() {

        var stamp = Timer.stamp();
        var data = File.getContent(dataFile).split('\n');
        data.remove("");

        var bottomRight = {
            "x": 0,
            "y": 0
        }
        // Find the bottom right most cord
        for (cord in data) {
            var x = Std.parseInt(cord.split(", ")[0]);
            var y = Std.parseInt(cord.split(", ")[1]);

            if (bottomRight.x < x) {
                bottomRight.x = x;
            }
            if (bottomRight.y < y) {
                bottomRight.y = y;
            }
        }
        bottomRight.x += 1;
        bottomRight.y += 1;
        var grid:Array<Array<Int>> = [ for (x in 0...bottomRight.x) [ for (y in 0...bottomRight.y) -1 ]];
        var count:Array<Int> = [ for (x in 0...data.length+1) 0 ];
        for (z in 0...data.length) {
            var x = Std.parseInt(data[z].split(", ")[0]);
            var y = Std.parseInt(data[z].split(", ")[1]);
            grid[x][y] = z;
        }

        for (x in 0...bottomRight.x) {
            for (y in 0...bottomRight.y) {
                var closestDist:Float = 999999.0;
                var closestWhich:Int = -1;

                // Something is fishy here
                for (z in 0...data.length) {
                    var cordx = Std.parseInt(data[z].split(", ")[0]);
                    var cordy = Std.parseInt(data[z].split(", ")[1]);

                    var xd = cordx-x;
                    var yd = cordy-y;

                    var dist = Math.round(Math.sqrt(xd*xd + yd*yd));
                    if (dist < closestDist) {
                        closestDist = dist;
                        closestWhich = z+1;
                    } else if (dist == closestDist) {
                        closestDist = 0;
                        closestWhich = -1;
                    }
                }
                grid[x][y] = closestWhich;
                if (x == 0 || x == bottomRight.x || y == 0 || y == bottomRight.y) {
                    count[closestWhich] = -1;
                }
                if (closestWhich != -1 && count[closestWhich] != -1) {
                    count[closestWhich] += 1;
                }
            }
        }

        trace(count);
        
        var stopStamp = Timer.stamp();

        trace("Part 1 Result: ");
        trace("Part 2 Result: ");
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}
