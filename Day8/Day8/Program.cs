using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace Day8
{
    class Block
    {
        public Block(Stack<int> parsedData)
        {
            numberOfChildren = parsedData.Pop();
            numberOfMetadata = parsedData.Pop();
            metadata = new int[numberOfMetadata];
            childBlocks = new Block[numberOfChildren];
            for (var x = 0; x < numberOfChildren; x++)
            {
                childBlocks[x] = new Block(parsedData);
            }
            for (var x = 0; x < numberOfMetadata; x++)
            {
                metadata[x] = parsedData.Pop();
                metaSum += metadata[x];
            }
        }

        public int GetAllMetadataCount()
        {
            int sum = 0;
            sum += metaSum;
            for (var x = 0; x < numberOfChildren; x++)
            {
                sum += childBlocks[x].GetAllMetadataCount();
            }
            return sum;
        }
        public int GetMetadataCount()
        {
            if (numberOfChildren > 0)
            {
                int sum = 0;
                for (var x = 0; x < numberOfMetadata; x++)
                {
                    if (metadata[x] != 0 && metadata[x] <= numberOfChildren)
                    {
                        sum += childBlocks[metadata[x]-1].GetMetadataCount();
                    }
                }

                return sum;
            }
            return metaSum;
        }

        private readonly int numberOfChildren = -1;
        private readonly int numberOfMetadata = -1;
        private readonly int[] metadata;
        private readonly Block[] childBlocks;
        private readonly int metaSum = 0;
    }
    class Program
    {
        public static string DATAFILE = "input";

        static void Main(string[] args)
        {
            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();
            string data = System.IO.File.ReadAllText(DATAFILE);
            string[] splitData = data.Split(' ');
            Stack<int> parsedData = new Stack<int>();
            for (var x = splitData.Length-1; x >= 0; x--)
            {
                int parsedInt = -1;
                int.TryParse(splitData[x], out parsedInt);
                parsedData.Push(parsedInt);
            }

            int maxLength = parsedData.Count / 2 + 1;
            int answerPartOne = 0;
            int answerPartTwo = 0;

            Block masterBlock = new Block(parsedData);
            answerPartOne = masterBlock.GetAllMetadataCount();
            answerPartTwo = masterBlock.GetMetadataCount();
            stopWatch.Stop();
            TimeSpan ts = stopWatch.Elapsed;

            Console.WriteLine("Part 1: " + answerPartOne);
            Console.WriteLine("Part 2: " + answerPartTwo);
            Console.WriteLine("RunTime: " + ts);

            Console.ReadKey();
        }
    }
}
