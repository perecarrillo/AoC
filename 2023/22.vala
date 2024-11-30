class Coord {
    public int x;
    public int y;
    public int z;

    public Coord(int i, int j, int k) {
        x = i;
        y = j;
        z = k;
    }

    public bool isAbove(Coord other) {
        if (x == other.x && y == other.y) return z > other.z;
        return false;
    }

    public int canFall(Brick brick) {
        var minDist = int.MAX;
        if (!brick.isDesintegrated) {
            foreach (var c in brick.tiles) {
                if (isAbove(c)) {
                    var dist = z - c.z - 1;
                    if (dist < minDist) minDist = dist;
                }
            }
        }
        return minDist;
    }
}


class Brick {
    public int[] start;
    public int[] end;
    public Coord[] tiles;
    public bool isDesintegrated;
    public int id;

    public Brick(int idx, string brick) {
        string[] sp = brick.split("~");
        string[] startString = sp[0].split(",");
        start = new int[3];
        start[0] = int.parse(startString[0]);
        start[1] = int.parse(startString[1]);
        start[2] = int.parse(startString[2]);
        string[] endString = sp[1].split(",");
        end = new int[3];
        end[0] = int.parse(endString[0]);
        end[1] = int.parse(endString[1]);
        end[2] = int.parse(endString[2]);

        tiles = {};
        for (var i = start[0]; i <= end[0]; ++i) {
            for (var j = start[1]; j <= end[1]; ++j) {
                for (var k = start[2]; k <= end[2]; ++k) {
                    tiles += new Coord(i,j,k);
                }
            }
        }
        isDesintegrated = false;
        id = idx;
    }

    public Brick.copy(Brick b) {
        start = new int[3];
        start[0] = b.start[0];
        start[1] = b.start[1];
        start[2] = b.start[2];
        end = new int[3];
        end[0] = b.end[0];
        end[1] = b.end[1];
        end[2] = b.end[2];

        tiles = {};
        for (var i = start[0]; i <= end[0]; ++i) {
            for (var j = start[1]; j <= end[1]; ++j) {
                for (var k = start[2]; k <= end[2]; ++k) {
                    tiles += new Coord(i,j,k);
                }
            }
        }
        isDesintegrated = b.isDesintegrated;
        id = b.id;
    }

    public string toString() {
        return "Brick " + id.to_string() + ": " + start[0].to_string() + "," + start[1].to_string() + "," + start[2].to_string() + "~" + end[0].to_string() + "," + end[1].to_string() + "," + end[2].to_string();
    }

    public bool fall(Brick[] bricks) {
        var maxFall = int.MAX;
        foreach(var tile in tiles) {
            foreach(var brick in bricks) {
                if (brick != this) {
                    var canFall = tile.canFall(brick);
                    if (canFall < maxFall) maxFall = canFall;
                }
            }
        }

        //  stdout.printf("Falling: %d\n", maxFall);

        if (maxFall != 0 && start[2] != 1) {
            if (maxFall == int.MAX) {
                maxFall = start[2] - 1;
            }
            start[2] -= maxFall;
            end[2] -= maxFall;
            foreach (var c in tiles) {
                c.z -= maxFall;
            }
            return true;
        }
        return false;
    }

}

int checkBrick(Brick brick, Brick[] oldBricks) {


    Brick[] bricks = {};
    foreach (var br in oldBricks) {
        bricks += new Brick.copy(br);
        if (bricks[bricks.length - 1].id == brick.id ) bricks[bricks.length - 1].isDesintegrated = true;
    }

    stdout.printf("Checking %s\n", brick.toString());
    bool[] counted = new bool[oldBricks.length];

    var sum = 0;

    var falling = true;
    while (falling) {
        stdout.printf("New iteration. partial sum = %d\n", sum);

        falling = false;
        foreach (var b in bricks) {
            var f = b.fall(bricks);
            falling = f || falling;
            if (f && !counted[b.id]) {
                ++sum;
                counted[b.id] = true;
            }
        }
    }
    return sum;
}

int cmp(ref Brick x, ref Brick y) {
    if (x.start[2] < y.start[2]) return 1;
    if (x.start[2] > y.start[2]) return -1;
    if (x.end[2] < y.end[2]) return 1;
    if (x.end[2] > y.end[2]) return -1;
    return 0;
}

class Worker {
    public Brick brick;
    public Brick[] bricks;

    public Worker (Brick brick, Brick[] bricks) {
        this.brick = brick;
        this.bricks = bricks;
    }
}

void main(string[] args) {
    var line = stdin.read_line();
    Brick[] bricks = {};
    var id = 0;
    while (line != "DONE") {
        var b = new Brick(id, line);
        bricks += b;
        ++id;
        line = stdin.read_line();
    }

    Posix.qsort (bricks, bricks.length, sizeof(Brick), (Posix.compar_fn_t) cmp);

    foreach (var b in bricks) stdout.printf("%s\n", b.toString());

    var falling = true;
    while (falling) {
        stdout.printf("New Iteration\n");
        falling = false;
        foreach (var b in bricks) {
            //  stdout.printf("Brick falling from %s to ", b.toString());
            falling = b.fall(bricks) || falling;
            //  stdout.printf("%s\n", b.toString());
        }
    }
    
    var sum = 0;
    
    Mutex mutex = Mutex ();
    var nTasks = bricks.length;

    var stillRunning = 0;

    var pool = new ThreadPool<Worker>.with_owned_data ((worker) => {
        var localSum = checkBrick(worker.brick, worker.bricks);

        //  g_mutex_lock(&mutex);
        mutex.lock();
        stdout.printf("Entering lock for %s, my localSum = %d\n", worker.brick.toString(), localSum);
        sum += localSum;
        stillRunning -= 1;
        stdout.printf("Exiting lock for %s\n", worker.brick.toString());
        mutex.unlock();
        //  g_mutex_unlock(&mutex);
    }, nTasks, true);

    foreach (var b in bricks) {
        stillRunning += 1;
        pool.add(new Worker(b, bricks));
        //  sum += checkBrick(b, bricks);
    }

    while(stillRunning > 0) {
        Thread.usleep(2000000);
    }

    //  stdout.printf("Part one solution: %d\n", sum);
    stdout.printf("Part two solution: %d\n", sum);

    

}