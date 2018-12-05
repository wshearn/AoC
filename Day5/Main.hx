import haxe.Timer;
import sys.io.File;

class Main {
    static var charDiff:Int = 32;

    static function removeFromAray(array:Array<String>) {
        var endCheck = array.length - 1;
        for (x in 0...endCheck) {
            if (array.length <= x) {
                break;
            }
            var currentChar = array[x].charCodeAt(0);
            var nextChar =  array[x+1].charCodeAt(0);
            if (currentChar == (nextChar - charDiff) || 
                currentChar == (nextChar + charDiff)) {
                array.splice(x, 2);
                return array;
            }
        }
        return null;
    }

    static function main() {
        
        var stamp = Timer.stamp();
        var data = File.getContent("input").split('');
        data.remove("");
        var changed:Bool = false;
        
        var partOne:Int = 0;
        var partTwo:Int = 9999999;

        // Slow af
        while (true) {
            changed = false;

            var newArray = removeFromAray(data);
            if (newArray != null) {
                data = newArray;
                changed = true;
            }

            if (!changed) {
                break;
            }
        }

        partOne = data.length;

        for (x in 65...91) {
            var newArray = data.copy();

            while (newArray.remove(String.fromCharCode(x))) {} 
            while (newArray.remove(String.fromCharCode(x+charDiff))) {}

            var changed:Bool = false;

            while (true) {
                changed = false;

                var testArray = removeFromAray(newArray);
                if (testArray != null) {
                    newArray = testArray;
                    changed = true;
                }

                if (!changed) {
                    break;
                }
            }

            if (newArray.length < partTwo) {
                partTwo = newArray.length;
            }
        }

        var stopStamp = Timer.stamp();

        trace("Part 1 Result: " + partOne);
        trace("Part 2 Result: " + partTwo);
        trace("Time in seconds it took to run: " + (stopStamp-stamp));
    }
}
