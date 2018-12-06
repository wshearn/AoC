import haxe.Timer;
import sys.io.File;

class Main {
    //static var dataFile = "input.sample";
    static var dataFile = "input";
    static function main() {

        var stamp = Timer.stamp();
        var data = File.getContent(dataFile).split('\n');
        data.remove("");
        var parsedCords:Array<{y: Null<Int>, x: Null<Int>}> = [ for (x in 0...data.length-1) {x: -1, y: -1} ];
        for (cord in 0...data.length) {
            var newMap = {
                "x": Std.parseInt(data[cord].split(", ")[1]),
                "y": Std.parseInt(data[cord].split(", ")[0])
            }
            parsedCords[cord] = newMap;
        }

        var bottomRight = {
            "x": 0,
            "y": 0
        }
        // Find the bottom right most cord
        for (cord in parsedCords) {
            if (bottomRight.x < cord.y) {
                bottomRight.x = cord.x;
            }
            if (bottomRight.y < cord.y) {
                bottomRight.y = cord.y;
            }
        }
        bottomRight.x += 100;
        bottomRight.y += 100;

        var count:Array<Int> = [ for (x in 0...data.length) 0 ];
        var glob:Int = 0;
        var globDist:Int = 10000;

        for (x in 0...bottomRight.x) {

            for (y in 0...bottomRight.y) {
                var closestDist:Int = 999999;
                var closestWhich:Int = -1;
                var pointDistGlob:Int = 0;

                for (z in 0...data.length) {
                    var xd = Std.int(Math.abs(x - parsedCords[z].x));
                    var yd = Std.int(Math.abs(y - parsedCords[z].y));

                    var dist = xd+yd;
                    if (dist == closestDist) {
                        closestWhich = -1;
                    }

                    if (x == parsedCords[z].x && y == parsedCords[z].y) {
                        closestDist = -1;
                        closestWhich = z;
                    }

                    if (dist < closestDist) {
                        closestDist = dist;
                        closestWhich = z;
                    }
                    pointDistGlob += dist;
                }
                if (x == 0 || x == bottomRight.x-1 || y == 0 || y == bottomRight.y-1) {
                    count[closestWhich] = -1;
                }
                if (closestWhich != -1 && count[closestWhich] != -1) {
                    count[closestWhich] += 1;
                }

                if (pointDistGlob < globDist) {
                    glob++;
                }
            }
        }

        count.sort(function(x, y) {
            if (x == -1) return 1;
            if (y == -1) return -1;
            if (x > y) return -1;
            if (x == y) return 0;
            return 1;
        });
        var stopStamp = Timer.stamp();

        trace("Part 1 Result: " + count[0]);
        trace("Part 2 Result: " + glob);
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}
