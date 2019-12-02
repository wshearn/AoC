class Main {
    public static function main() {
        var totalFuel = 0;

        var fileIn = sys.io.File.read("input", false);
        try {
            while(true) {
                var line = fileIn.readLine();
                var needed = Std.parseInt(line);
                totalFuel += Math.floor(needed/3)-2;
            }
        } catch (e:haxe.io.Eof) {
            fileIn.close();
        }

        trace(totalFuel);

        // Part 2
        var totalFuelOfFuel = 0;
        fileIn = sys.io.File.read("input", false);
        try {
            while(true) {
                var line = fileIn.readLine();
                var needed = Std.parseInt(line);
                var moduleFuel = 0;
                var currentFuel = 0;
                while(currentFuel >= 0) {
                    currentFuel = Math.floor(needed/3)-2;
                    if (currentFuel > 0) {
                        moduleFuel += currentFuel;
                    }
                    needed = currentFuel;
                }
                totalFuelOfFuel += moduleFuel;
                
            }
        } catch (e:haxe.io.Eof) {
            fileIn.close();
        }

        trace(totalFuelOfFuel);
    }
}