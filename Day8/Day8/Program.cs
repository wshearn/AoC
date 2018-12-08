using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Day8
{
    class Block
    {
        public Block(Stack<int> parsedData, Block parent)
        {
            numberOfChildren = parsedData.Pop();
            numberOfMetadata = parsedData.Pop();
            metadata = new int[numberOfMetadata];
            childBlocks = new Block[numberOfChildren];
            for (var x = 0; x < numberOfChildren; x++)
            {
                childBlocks[x] = new Block(parsedData, this);
            }
            for (var x = 0; x < numberOfMetadata; x++)
            {
                metadata[x] = parsedData.Pop();
            }
            this.parent = parent;
        }

        public int getAllMetadataCount()
        {
            int sum = 0;
            sum += metadata.Sum();
            for (var x = 0; x < numberOfChildren; x++)
            {
                sum += childBlocks[x].getAllMetadataCount();
            }
            return sum;
        }
        public int getMetadataCount()
        {
            if (numberOfChildren > 0)
            {
                int sum = 0;
                for (var x = 0; x < numberOfMetadata; x++)
                {
                    if (metadata[x] != 0 && metadata[x] <= numberOfChildren)
                    {
                        sum += childBlocks[metadata[x]-1].getMetadataCount();
                    }
                }

                return sum;
            }
            return metadata.Sum();
        }

        private readonly int numberOfChildren = -1;
        private readonly int numberOfMetadata = -1;
        private int[] metadata;
        private readonly Block[] childBlocks;
        private readonly Block parent;
    }
    class Program
    {
        public static string DATAFILE = "input";

        static void Main(string[] args)
        {
            // The code provided will print ‘Hello World’ to the console.
            // Press Ctrl+F5 (or go to Debug > Start Without Debugging) to run your app.
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
            //Block[] blocks = new Block[maxLength];
            Block masterBlock = new Block(parsedData, null);
            answerPartOne = masterBlock.getAllMetadataCount();
            answerPartTwo = masterBlock.getMetadataCount();

            Console.WriteLine(answerPartOne);
            Console.WriteLine(answerPartTwo);
            Console.ReadKey();
        }
    }
}
