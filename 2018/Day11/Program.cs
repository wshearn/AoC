using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace Day11
{
    class Program
    {
        // Sample
        //static Int32 input = 18;
        // My Input
        static Int32 input = 4842;
        static Int32 GridSize = 300;

        static void Main(string[] args)
        {
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();

            Int32[,] grid = new Int32[GridSize+1, GridSize+1];

            for (Int32 y = 1; y <= GridSize-2; y++) {
                for (Int32 x = 1; x <= GridSize-2; x++) {
                    var power = 0;
                    var rackId = x+10;
                    power = rackId * y;
                    power += input;
                    power *= rackId;
                    if (power < 100) {
                        power = 0;
                    } else {
                        power = (Int32)Math.Floor((double)(power % 1000) / 100);
                    }
                    power -= 5;
                    grid[x, y] = power;
                }
            }

            var currentMaxX = -1;
            var currentMaxY = -1;
            var currentMaxSize = 3;
            var currentMaxPower = 0;
            var p2currentMaxX = -1;
            var p2currentMaxY = -1;
            var p2currentMaxSize = 3;
            var p2currentMaxPower = 0;
            // While the puzzle says it can be up to 300, there is the principle of indifference
            // Which when applied to this we should be able to get our answer within 27 loops or so starting at 3
            for (Int32 size = GridSize/100; size <= GridSize/10; size++)
            {
                for (Int32 y = 1; y <= GridSize-size-1; y++) {
                    for (Int32 x = 1; x <= GridSize-size-1; x++) {
                        Int32 currentPower = 0;
                        for (Int32 y2 = 0; y2 < size; y2++) {
                            for (Int32 x2 = 0; x2 < size; x2++) {
                                currentPower += grid[x+x2, y+y2];
                            }
                        }
                        if (currentPower > p2currentMaxPower) {
                            p2currentMaxPower = currentPower;
                            p2currentMaxX = x;
                            p2currentMaxY = y;
                            p2currentMaxSize = size;
                        }
                        if (size == 3 && currentPower > currentMaxPower) {
                            currentMaxPower = currentPower;
                            currentMaxX = x;
                            currentMaxY = y;
                            currentMaxSize = size;
                        }
                    }
                }
            }

            var partOneAnswer = currentMaxX + "," + currentMaxY;
            var partTwoAnswer = p2currentMaxX + "," + p2currentMaxY + "," + p2currentMaxSize;

            stopWatch.Stop();
            TimeSpan ts = stopWatch.Elapsed;

            Console.WriteLine("Part 1: " + partOneAnswer);
            Console.WriteLine("Part 2: " + partTwoAnswer);
            Console.WriteLine("RunTime: " + ts);            
        }
    }
}
