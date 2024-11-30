import java.io.File;
import java.io.IOException;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.concurrent.ThreadLocalRandom;

public class Main17 {

    static public class Quadruplet<T> implements Comparable<Quadruplet<T>> {
        public T i;
        public T j;
        public T d;
        public T c;
        public Integer cost;

        public Quadruplet(T x, T y, T dir, T straight, Integer cost) {
            i = x;
            j = y;
            d = dir;
            c = straight;
            this.cost = cost;
        }

        public String toString() {
            return "[" + i + "," + j + "," + d + "," + c + "] = " + cost;
        }

        @Override
        public int compareTo(Quadruplet<T> other) {
            if (this.cost > other.cost)
                return 1;
            if (this.cost < other.cost)
                return -1;
            return 0;
        }

    }

    public static void main(String[] args) throws IOException {

        final Integer UP = 0;
        final Integer RIGHT = 1;
        final Integer DOWN = 2;
        final Integer LEFT = 3;

        System.out.println("A");
        Scanner scanner = new Scanner(new File("17.in"));

        ArrayList<int[]> stringMap = new ArrayList<int[]>();
        int rows = 0, cols = 0;
        while (scanner.hasNextLine()) {
            // System.out.println(scanner.nextLine());
            char[] line = scanner.nextLine().toCharArray();
            int[] ints = new int[line.length];
            cols = line.length;
            Arrays.setAll(ints, i -> Character.getNumericValue(line[i]));
            stringMap.add(ints);
            ++rows;
        }
        int[][] map = stringMap.toArray(new int[rows][cols]);
        // System.out.println(Arrays.deepToString(map));

        int[][][][] visited = new int[rows][cols][4][11];
        for (int i = 0; i < rows; ++i)
            for (int j = 0; j < cols; ++j)
                for (int k = 0; k < 4; ++k)
                    for (int l = 0; l < 11; ++l)
                        visited[i][j][k][l] = Integer.MAX_VALUE;

        Queue<Quadruplet<Integer>> DFS = new PriorityQueue<Quadruplet<Integer>>();
        // 0^ 1> 2v 3<
        DFS.add(new Quadruplet<Integer>(0, 0, DOWN, 1, 0));
        DFS.add(new Quadruplet<Integer>(0, 0, RIGHT, 1, 0));
        visited[0][0][DOWN][1] = 0;
        visited[0][0][RIGHT][1] = 0;
        // System.out.println("Rows: " + visited.length + " Cols: " +
        // visited[0].length);
        int it = 0;
        while (!DFS.isEmpty()) {
            Quadruplet<Integer> p = DFS.remove();

            ++it;
            if (it % 10000000 == 0) {
                System.out.println(p);
                System.out.println("Queue size: " + DFS.size());
            }

            if (visited[p.i][p.j][p.d][p.c] < p.cost)
                continue;

            visited[p.i][p.j][p.d][p.c] = p.cost;

            if (p.i == rows - 1 && p.j == cols - 1)
                break;

            // UP
            // if (p.j > 0 && p.d != DOWN && !(p.d == UP && p.c > 3)) { // Part one
            if (p.j > 0 && p.d != DOWN && !(p.d == UP && p.c >= 10 || p.d != UP && p.c < 4)) { // Part Two
                // System.out.println("Adding UP " + new Quadruplet<Integer>(p.i, p.j - 1, UP,
                // p.d == UP ? p.c + 1 : 1,
                // p.cost + map[p.i][p.j - 1]));
                DFS.add(new Quadruplet<Integer>(p.i, p.j - 1, UP, p.d == UP ? p.c + 1 : 1, p.cost + map[p.i][p.j - 1]));
            }

            // DOWN
            // if (p.j < cols - 1 && p.d != UP && !(p.d == DOWN && p.c > 3)) { // Part One
            if (p.j < cols - 1 && p.d != UP && !(p.d == DOWN && p.c >= 10 || p.d != DOWN && p.c < 4)) { // Part two
                // System.out
                // .println("Adding DOWN " + new Quadruplet<Integer>(p.i, p.j + 1, DOWN, p.d ==
                // DOWN ? p.c + 1 : 1,
                // p.cost + map[p.i][p.j + 1]));
                DFS.add(new Quadruplet<Integer>(p.i, p.j + 1, DOWN, p.d == DOWN ? p.c + 1 : 1,
                        p.cost + map[p.i][p.j + 1]));
            }

            // LEFT
            // if (p.i > 0 && p.d != RIGHT && !(p.d == LEFT && p.c > 3)) { // Part One
            if (p.i > 0 && p.d != RIGHT && !(p.d == LEFT && p.c >= 10 || p.d != LEFT && p.c < 4)) { // Part Two
                // System.out
                // .println("Adding LEFT " + new Quadruplet<Integer>(p.i - 1, p.j, LEFT, p.d ==
                // LEFT ? p.c + 1 : 1,
                // p.cost + map[p.i - 1][p.j]));
                DFS.add(new Quadruplet<Integer>(p.i - 1, p.j, LEFT, p.d == LEFT ? p.c + 1 : 1,
                        p.cost + map[p.i - 1][p.j]));
            }

            // RIGHT
            // if (p.i < rows - 1 && p.d != LEFT && !(p.d == RIGHT && p.c > 3)) { // Part
            // One
            if (p.i < rows - 1 && p.d != LEFT && !(p.d == RIGHT && p.c >= 10 || p.d != RIGHT && p.c < 4)) { // Part Two
                // System.out.println(
                // "Adding RIGHT " + new Quadruplet<Integer>(p.i + 1, p.j, RIGHT, p.d == RIGHT ?
                // p.c + 1 : 1,
                // p.cost + map[p.i + 1][p.j]));
                DFS.add(new Quadruplet<Integer>(p.i + 1, p.j, RIGHT, p.d == RIGHT ? p.c + 1 : 1,
                        p.cost + map[p.i + 1][p.j]));
            }

        }

        // System.out.println("Map size: " + map.length + ", " + map[0].length);

        int best = Integer.MAX_VALUE;

        for (int k = 0; k < 4; ++k)
            for (int l = 0; l < 11; ++l)
                best = Math.min(best, visited[rows - 1][cols - 1][k][l]);

        System.out.println("The best path has cost: " + best);

        scanner.close();
    }
}
