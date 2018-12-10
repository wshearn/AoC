using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;

namespace Day10
{
    struct Vector2
    {
        public Int32 x;
        public Int32 y;
    }

    class SkyPoint
    {
        public SkyPoint(string dataLine) {
            var posStr = dataLine.Split(">")[0].Split("=<")[1].Split(", ");
            position.x = Int32.Parse(posStr[0]);
            position.y = Int32.Parse(posStr[1]);

            var velStr = dataLine.Split("=<")[2].Split(">")[0].Split(", ");
            velocity.x = Int32.Parse(velStr[0]);
            velocity.y = Int32.Parse(velStr[1]);
        }

        public Vector2 GetPointAtTime(Int32 time)
        {
            Vector2 posInTime = position;

            posInTime.x += (velocity.x * time);
            posInTime.y += (velocity.y * time);

            return posInTime;
        }

        private Vector2 position;
        private Vector2 velocity;

    }
    class Program
    {
        public static string DATAFILE = "input";

        static void Main(string[] args)
        {
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();
            string data = System.IO.File.ReadAllText(DATAFILE);
            string[] splitData = data.Split('\n');
            Array.Sort(splitData);
            SkyPoint[] skyPoints = new SkyPoint[splitData.Length];

            // Day 10 Code here
            for (var x = 0; x < splitData.Length; x++) {
                skyPoints[x] = new SkyPoint(splitData[x]);
            }

            var time = 1;
            while (true) {
                Vector2[] pointsInTime = new Vector2[skyPoints.Length];
                
                for (var x = 0; x < skyPoints.Length; x++) {
                    pointsInTime[x] = skyPoints[x].GetPointAtTime(time);
                }

                var startingX = pointsInTime[0].x;
                var startingY = pointsInTime[0].y;
                var endingX = pointsInTime[0].x;
                var endingY = pointsInTime[0].y;

                foreach (var point in pointsInTime) {
                    if (point.x < startingX) {
                        startingX = point.x;
                    }
                    if (point.y < startingY) {
                        startingY = point.y;
                    }
                    if (point.x > endingX) {
                        endingX = point.x;
                    }
                    if (point.y > endingY) {
                        endingY = point.y;
                    }
                }

                if (Math.Abs(endingX - startingX) <= pointsInTime.Length &&
                    Math.Abs(endingY - startingY) <= 9) {

                    StreamWriter file = new StreamWriter(@"D:\Projects\Aoc18\Day10\Output.txt", false);
                    for (var y = startingY; y <= endingY; y++) {
                        for (var x = startingX; x <= endingX; x++) {
                            bool wasSet = false;
                            foreach(var point in pointsInTime) {
                                if (!wasSet) {
                                    if (point.x == x && point.y == y) {
                                        file.Write("#");
                                        wasSet = true;
                                    }
                                }
                            }
                            if (wasSet == false) {
                                file.Write(" ");    
                            }
                        }
                        file.WriteLine("");
                    }
                    file.Close();
                    break;
                }
                time++;
            }

            stopWatch.Stop();
            TimeSpan ts = stopWatch.Elapsed;

            Console.WriteLine("Part 1: " + "See D:\\Projects\\Aoc18\\Day10\\Output.txt");
            Console.WriteLine("Part 2: " + time);
            Console.WriteLine("RunTime: " + ts);
        }
    }
}