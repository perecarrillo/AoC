#include <stdio.h>
#define MAP_SIZE 110 // 110 real input
#define max(x, y) (((x) > (y)) ? (x) : (y))

char map[MAP_SIZE][MAP_SIZE];
int energy[MAP_SIZE][MAP_SIZE][4]; // All directions

struct Position
{
    int x, y;
};

struct Position getNextPosition(struct Position p, int direction)
{
    struct Position next = p;
    switch (direction)
    {
    case 0:
        --next.x;
        break;
    case 1:
        ++next.y;
        break;
    case 2:
        ++next.x;
        break;
    case 3:
        --next.y;
        break;
    default:
        break;
    }
    return next;
}

//                               0^ 1> 2v 3<
void beam(struct Position p, int direction)
{
    if (p.x < 0 || p.x >= MAP_SIZE || p.y < 0 || p.y >= MAP_SIZE || (energy[p.x][p.y][direction]))
        return;

    // printf("Energizing cell %d, %d. Going direction %d\n", p.x, p.y, direction);
    ++energy[p.x][p.y][direction];

    if (map[p.x][p.y] == '/')
    {
        if (direction == 0)
            return beam(getNextPosition(p, 1), 1);
        else if (direction == 1)
            return beam(getNextPosition(p, 0), 0);
        else if (direction == 2)
            return beam(getNextPosition(p, 3), 3);
        else
            return beam(getNextPosition(p, 2), 2);
    }
    else if (map[p.x][p.y] == '\\')
    {
        if (direction == 0)
            return beam(getNextPosition(p, 3), 3);
        else if (direction == 1)
            return beam(getNextPosition(p, 2), 2);
        else if (direction == 2)
            return beam(getNextPosition(p, 1), 1);
        else
            return beam(getNextPosition(p, 0), 0);
    } //                               0^ 1> 2v 3<
    else if (map[p.x][p.y] == '|' && direction % 2 == 1)
    {
        beam(getNextPosition(p, 0), 0);
        beam(getNextPosition(p, 2), 2);
        return;
    }
    else if (map[p.x][p.y] == '-' && direction % 2 == 0)
    {
        beam(getNextPosition(p, 1), 1);
        beam(getNextPosition(p, 3), 3);
        return;
    }
    else
    {
        return beam(getNextPosition(p, direction), direction);
    }
}

int countEnergized()
{
    int energized = 0;
    for (int i = 0; i < MAP_SIZE; ++i)
    {
        for (int j = 0; j < MAP_SIZE; ++j)
        {
            if (energy[i][j][0] || energy[i][j][1] || energy[i][j][2] || energy[i][j][3])
            {
                ++energized;
                // printf("(%d, %d) ", i, j);
            }
        }
        // printf("\n");
    }
    return energized;
}

int main()
{
    for (int i = 0; i < MAP_SIZE; ++i)
    {
        scanf("%s", map[i]);
    }

    struct Position p;

    int maxEnergy = 0;
    for (int i = 0; i < MAP_SIZE; ++i)
    {
        for (int x = 0; x < MAP_SIZE; ++x)
            for (int y = 0; y < MAP_SIZE; ++y)
                for (int z = 0; z < 4; ++z)
                    energy[x][y][z] = 0;

        // 0^ 1> 2v 3<
        p.x = 0;
        p.y = i;
        beam(p, 2);
        maxEnergy = max(maxEnergy, countEnergized());

        for (int x = 0; x < MAP_SIZE; ++x)
            for (int y = 0; y < MAP_SIZE; ++y)
                for (int z = 0; z < 4; ++z)
                    energy[x][y][z] = 0;

        p.x = MAP_SIZE - 1;
        p.y = i;
        beam(p, 0);
        maxEnergy = max(maxEnergy, countEnergized());

        for (int x = 0; x < MAP_SIZE; ++x)
            for (int y = 0; y < MAP_SIZE; ++y)
                for (int z = 0; z < 4; ++z)
                    energy[x][y][z] = 0;

        p.x = i;
        p.y = 0;
        beam(p, 1);
        maxEnergy = max(maxEnergy, countEnergized());

        for (int x = 0; x < MAP_SIZE; ++x)
            for (int y = 0; y < MAP_SIZE; ++y)
                for (int z = 0; z < 4; ++z)
                    energy[x][y][z] = 0;

        p.x = i;
        p.y = MAP_SIZE - 1;
        beam(p, 3);
        maxEnergy = max(maxEnergy, countEnergized());
    }

    // int energized = countEnergized();

    printf("Energized tiles: %d\n", maxEnergy);

    return 0;
}