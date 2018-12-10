import haxe.Timer;
import sys.io.File;

class Main {
    static var dataFile = "input";
    static function main() {

        var stamp = Timer.stamp();
        var data = File.getContent(dataFile).split('\n');
        data.remove("");
        var parsedCords:Array<{y: Null<Int>, x: Null<Int>}> = [ for (x in 0...data.length-1) {x: -1, y: -1} ];
        var bottomRight = {
            "x": 0,
            "y": 0
        }
        var topLeft = {
            "x": 1000,
            "y": 1000
        }
        for (cord in 0...data.length) {
            var splitCord = data[cord].split(", ");

            parsedCords[cord] = {
                "x": Std.parseInt(splitCord[0]),
                "y": Std.parseInt(splitCord[1])
            }

            if (topLeft.x > parsedCords[cord].x) {
                topLeft.x = parsedCords[cord].x;
            }
            if (topLeft.y > parsedCords[cord].y) {
                topLeft.y = parsedCords[cord].y;
            }

            if (bottomRight.x < parsedCords[cord].x) {
                bottomRight.x = parsedCords[cord].x;
            }
            if (bottomRight.y < parsedCords[cord].y) {
                bottomRight.y = parsedCords[cord].y;
            }
        }

        var count:Array<Int> = [ for (x in 0...data.length) 0 ];
        var glob:Int = 0;
        var globDist:Int = 10000;

        for (x in topLeft.x...bottomRight.x) {
            for (y in topLeft.y...bottomRight.y) {
                var closestDist:Int = 999999;
                var closestWhich:Int = -1;
                var pointDistGlob:Float = 0;

                for (z in 0...data.length) {
                    var xd = Math.abs(x - parsedCords[z].x);
                    var yd = Math.abs(y - parsedCords[z].y);

                    var dist = xd+yd;

                    if (dist < closestDist) {
                        closestDist = Std.int(dist);
                        closestWhich = z;
                    } else if (dist == closestDist) {
                        closestWhich = -1;
                    }

                    pointDistGlob += dist;
                }
                if (x == topLeft.x || x == bottomRight.x || y == topLeft.y || y == bottomRight.y) {
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
