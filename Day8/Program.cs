using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace Day8
{
    class Block
    {
        public Block(Queue<Int32> parsedData)
        {
            numberOfChildren = parsedData.Dequeue();
            numberOfMetadata = parsedData.Dequeue();
            metadata = new Int32[numberOfMetadata];
            childBlocks = new Block[numberOfChildren];
            for (var x = 0; x < numberOfChildren; x++)
            {
                childBlocks[x] = new Block(parsedData);
            }
            for (var x = 0; x < numberOfMetadata; x++)
            {
                metadata[x] = parsedData.Dequeue();
                metaSum += metadata[x];
            }
        }

        public Int32 GetAllMetadataCount()
        {
            Int32 sum = 0;
            sum += metaSum;
            for (var x = 0; x < numberOfChildren; x++)
            {
                sum += childBlocks[x].GetAllMetadataCount();
            }
            return sum;
        }
        public Int32 GetMetadataCount()
        {
            if (numberOfChildren > 0)
            {
                Int32 sum = 0;
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

        private readonly Int32 numberOfChildren = -1;
        private readonly Int32 numberOfMetadata = -1;
        private readonly Int32[] metadata;
        private readonly Block[] childBlocks;
        private readonly Int32 metaSum = 0;
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
            Queue<Int32> parsedData = new Queue<Int32>();
            foreach (var x in splitData)
            {
                Int32 parsedInt32 = -1;
                Int32.TryParse(x, out parsedInt32);
                parsedData.Enqueue(parsedInt32);
            }

            Int32 maxLength = parsedData.Count / 2 + 1;
            Int32 answerPartOne = 0;
            Int32 answerPartTwo = 0;

            Block masterBlock = new Block(parsedData);
            answerPartOne = masterBlock.GetAllMetadataCount();
            answerPartTwo = masterBlock.GetMetadataCount();
            stopWatch.Stop();
            TimeSpan ts = stopWatch.Elapsed;

            Console.WriteLine("Part 1: " + answerPartOne);
            Console.WriteLine("Part 2: " + answerPartTwo);
            Console.WriteLine("RunTime: " + ts);
        }
    }
}
