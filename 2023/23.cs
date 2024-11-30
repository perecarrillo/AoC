using System;
using System.Linq;
using System.Collections.Generic;
using System.Text;

class Program
{
    struct Position
    {
        public bool[,] visited;
        public int i;
        public int j;
        public Position(int x, int y, ref bool[,] vis)
        {
            i = x;
            j = y;
            visited = (bool[,])vis.Clone();
            visited[i, j] = true;
        }
    }

    static bool insideMap(ref StringBuilder[] map, int row, int col)
    {
        if (row < 0 || row >= map.Length || col < 0 || col >= map[0].Length) return false;
        return true;
    }

    static void Main(string[] args)
    {
        StringBuilder[] map = new StringBuilder[0];
        string line = Console.ReadLine();
        while (line != "DONE")
        {
            map = map.Append(new StringBuilder(line)).ToArray();

            line = Console.ReadLine();
        }
        // foreach (var l in map) Console.WriteLine(l);

        var visited = new bool[map.Length, map.Length];

        var start = new Position(0, 1, ref visited);

        var endi = map.Length - 1;

        var queue = new PriorityQueue<Position, int>(Comparer<int>.Create((x, y) => y - x)); // It's still NP, but faster than bfs/dfs

        queue.Enqueue(start, 0);

        var maxDist = -1;


        while (queue.Count > 0)
        {
            Position next;
            int len;
            queue.TryDequeue(out next, out len);

            int i = next.i;
            int j = next.j;

            // Console.WriteLine("Position: " + i.ToString() + " " + j.ToString() + " (" + map[i][j] + ")");

            if (i == endi)
            {
                if (len > maxDist)
                {
                    Console.WriteLine("Found distance: " + len.ToString());
                    maxDist = len;
                }
            }
            if (insideMap(ref map, i - 1, j) && !next.visited[i - 1, j] && map[i - 1][j] != '#') queue.Enqueue(new Position(i - 1, j, ref next.visited), len + 1);
            if (insideMap(ref map, i + 1, j) && !next.visited[i + 1, j] && map[i + 1][j] != '#') queue.Enqueue(new Position(i + 1, j, ref next.visited), len + 1);
            if (insideMap(ref map, i, j - 1) && !next.visited[i, j - 1] && map[i][j - 1] != '#') queue.Enqueue(new Position(i, j - 1, ref next.visited), len + 1);
            if (insideMap(ref map, i, j + 1) && !next.visited[i, j + 1] && map[i][j + 1] != '#') queue.Enqueue(new Position(i, j + 1, ref next.visited), len + 1);
        }

        Console.WriteLine("Max distance: " + maxDist.ToString());


    }
}