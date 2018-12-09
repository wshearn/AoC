using System;
using System.Diagnostics;
using System.Collections.Generic;

namespace Day9
{
    class Program
    {
        public static string DATAFILE = "input";
        static void Main(string[] args)
        {
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();

            string data = System.IO.File.ReadAllText(DATAFILE);
            string[] splitData = data.Split(' ');
            Int64 numberOfPlayers = 0;
            Int64.TryParse(splitData[0], out numberOfPlayers);

            Int64 lastMarble = 0;
            Int64.TryParse(splitData[6], out lastMarble);
            var partOneEnd = lastMarble;
            lastMarble = lastMarble * 100;
            long answerPartOne = 0;
            long answerPartTwo = 0;

            var tempMarbles = new LinkedListNode<Int64>[lastMarble+1];

            for (var x = 0; x <= lastMarble; x++) {
                tempMarbles[x] = new LinkedListNode<Int64>(x);
            }

            // Game setup.
            LinkedList<Int64> marbles = new LinkedList<Int64>();
            long[] elves = new long[numberOfPlayers];
            var currentMarble = marbles.AddFirst(0);

            var currentElf = 0;
            for (Int64 x = 1; x <= lastMarble; x++) {
                var nextMarble = tempMarbles[x];

                if (x % 23 == 0) {
                    elves[currentElf] += x;
                    for (var y = 0; y < 7; y++) {
                        if (currentMarble.Previous == null) {
                            currentMarble = marbles.Last;
                        } else {
                            currentMarble = currentMarble.Previous;
                        }
                    }

                    elves[currentElf] += currentMarble.Value;
                    currentMarble = currentMarble.Next;
                    marbles.Remove(currentMarble.Previous);
                } else {
                    if (x == 1) {
                        // Edge case for first marble
                        marbles.AddAfter(currentMarble, nextMarble);
                    } else {
                        if (currentMarble.Next != null) {
                            marbles.AddAfter(currentMarble.Next, nextMarble);
                        } else {
                            marbles.AddAfter(marbles.First, nextMarble);
                        }
                    }
                    currentMarble = nextMarble;
                }


                currentElf++;
                if (currentElf >= numberOfPlayers) {
                    currentElf = 0;
                }

                if (x == partOneEnd) {
                    foreach(var y in elves) {
                        if (y > answerPartOne) {
                            answerPartOne = y;
                        }
                    }
                }
            }

            foreach(var x in elves) {
                if (x > answerPartTwo) {
                    answerPartTwo = x;
                }
            }

            stopWatch.Stop();
            TimeSpan ts = stopWatch.Elapsed;

            Console.WriteLine("Part 1: " + answerPartOne);
            Console.WriteLine("Part 2: " + answerPartTwo);

            Console.WriteLine("RunTime: " + ts);
        }
    }
}
