import std.stdio;
import std.file;
import std.algorithm;


char[][] map;

void tiltNorth() {
    for (int j = 0; j < map[0].length; ++j) {
        int rocks = 0;
        for (int i = cast(int) map.length - 1; i >= 0; --i) {
            if (rocks != 0 && map[i][j] == '#') {
                for (int k = 1; k <= rocks; ++k) {
                    map[i+k][j] = 'O';
                }
                rocks = 0;
            }
            else if (map[i][j] == 'O') {
                // writeln("Found O in [", i, ",", j, "]");
                map[i][j] = '.';
                ++rocks;
            }
        }
        for (int k = 0; k < rocks; ++k) {
            map[k][j] = 'O';
        }
        rocks = 0;
        // writeln(map);
    }
}

void tiltSouth() {
    for (int j = 0; j < map[0].length; ++j) {
        int rocks = 0;
        for (int i = 0; i < map.length; ++i) {
            if (rocks != 0 && map[i][j] == '#') {
                for (int k = 1; k <= rocks; ++k) {
                    map[i-k][j] = 'O';
                }
                rocks = 0;
            }
            else if (map[i][j] == 'O') {
                // writeln("Found O in [", i, ",", j, "]");
                map[i][j] = '.';
                ++rocks;
            }
        }
        for (int k = 1; k <= rocks; ++k) {
            map[map.length - k][j] = 'O';
        }
        rocks = 0;
        // writeln(map);
    }
}

void tiltEast() {
    for (int i = 0; i < map.length; ++i) {
        int rocks = 0;
        for (int j = 0; j < map[0].length; ++j) {
            if (rocks != 0 && map[i][j] == '#') {
                for (int k = 1; k <= rocks; ++k) {
                    map[i][j-k] = 'O';
                }
                rocks = 0;
            }
            else if (map[i][j] == 'O') {
                // writeln("Found O in [", i, ",", j, "]");
                map[i][j] = '.';
                ++rocks;
            }
        }
        for (int k = 1; k <= rocks; ++k) {
            map[i][map[i].length - k] = 'O';
        }
        rocks = 0;
        // writeln(map);
    }
}

void tiltWest() {
    for (int i = 0; i < map.length; ++i) {
        int rocks = 0;
        for (int j = cast(int) map[0].length - 1; j >= 0; --j) {
            if (rocks != 0 && map[i][j] == '#') {
                for (int k = 1; k <= rocks; ++k) {
                    map[i][j+k] = 'O';
                }
                rocks = 0;
            }
            else if (map[i][j] == 'O') {
                // writeln("Found O in [", i, ",", j, "]");
                map[i][j] = '.';
                ++rocks;
            }
        }
        for (int k = 0; k < rocks; ++k) {
            map[i][k] = 'O';
        }
        rocks = 0;
        // writeln(map);
    }
}

ulong computeLoad() {
    ulong sum = 0;
    for (int i = 0; i < map.length; ++i) {
        for (int j = 0; j < map[0].length; ++j) {
            if (map[i][j] == 'O') {
                sum += map.length - i;
            }
        }
    }
    return sum;
}

void main(string[ ] args) {
    File file = File("./14.realin", "r");
    char[] line = file.readln().dup;
    int size = cast(int) line.length - 1;
    // line = line[0..size];
    
    while (!file.eof()) {
        // writeln(line);
        line = line[0..size];
        
        map ~= line;
    
        line = file.readln().dup;
        // line = file.readln().dup;
    }

    string[] visited;
    
    ulong loop;
    ulong start;

    for (ulong i = 0; i < 1000000000; ++i) {
        tiltNorth();
        tiltWest();
        tiltSouth();
        tiltEast();
        if (i % 100000 == 0) {
            writeln("Iteration ", i);
        }
        string copy;
        for (int j = 0; j < map.length; ++j) {
            copy ~= map[j].idup;
        }
        if (visited.canFind(copy)) {
            // writeln(visited);
            // writeln("----------------------------");
            // writeln(copy);
            ulong pos = visited.countUntil!(x => x == copy);
            writeln("Found it, iteration ", i);
            writeln("Found it in position ", pos);
            loop = i - pos;
            start = i;
            // writeln("Loop: ", loop, " Start: ", start);
            // writeln((1000000000 - start)%(loop));
            break;
        }
        visited ~= copy.dup;
    }

    for (ulong i = 1; i < ((1000000000 - start)%(loop)); ++i) {
        tiltNorth();
        tiltWest();
        tiltSouth();
        tiltEast();
    }
    
    
    ulong sum = computeLoad();
    
    
    
    writeln("Total Load: ", sum);
    // writeln(map);
    // for (int i = 0; i < map.length; ++i) {
        // writeln(map[i]);
    // }
}