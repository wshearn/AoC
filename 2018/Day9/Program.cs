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
            Int32 numberOfPlayers = 0;
            Int32.TryParse(splitData[0], out numberOfPlayers);

            Int32 lastMarble = 0;
            Int32.TryParse(splitData[6], out lastMarble);
            var partOneEnd = lastMarble;
            lastMarble = lastMarble * 100;
            Int64 answerPartOne = 0;
            Int64 answerPartTwo = 0;

            var tempMarbles = new LinkedListNode<Int32>[lastMarble+1];

            for (var x = 0; x <= lastMarble; x++) {
                tempMarbles[x] = new LinkedListNode<Int32>(x);
            }

            LinkedList<Int32> marbles = new LinkedList<Int32>();
            Int64[] elves = new Int64[numberOfPlayers];

            var currentMarble = marbles.AddFirst(0);
            var currentElf = 0;

            for (Int32 x = 1; x <= lastMarble; x++) {
                currentElf = (currentElf + 1) % numberOfPlayers;
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
                    if (currentMarble.Next != null) {
                        marbles.AddAfter(currentMarble.Next, nextMarble);
                    } else {
                        marbles.AddAfter(marbles.First, nextMarble);
                    }
                    currentMarble = nextMarble;
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
