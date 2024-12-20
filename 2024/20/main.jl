include("../utils.jl")

using Combinatorics

function getinput()
    return readlines("20/input.in", keep=false)
end

function solvemaze(maze, inii, inij, goali, goalj)
    visited = Set()
    tovisit = Set([(0, inii, inij),])
    obstaclesfound = Set()

    while !isempty(tovisit)
        d, i, j = popmin!(tovisit)

        if (i, j) in visited
            continue
        end
        push!(visited, (i, j))

        if i == goali && j == goalj
            return d, obstaclesfound
        end

        if isin(maze, i + 1, j) && maze[i+1][j] != '#'
            push!(tovisit, (d + 1, i + 1, j))
        elseif isin(maze, i + 1, j) && maze[i+1][j] == '#'
            push!(obstaclesfound, (i + 1, j))
        end
        if isin(maze, i - 1, j) && maze[i-1][j] != '#'
            push!(tovisit, (d + 1, i - 1, j))
        elseif isin(maze, i - 1, j) && maze[i-1][j] == '#'
            push!(obstaclesfound, (i - 1, j))
        end
        if isin(maze, i, j + 1) && maze[i][j+1] != '#'
            push!(tovisit, (d + 1, i, j + 1))
        elseif isin(maze, i, j + 1) && maze[i][j+1] == '#'
            push!(obstaclesfound, (i, j + 1))
        end
        if isin(maze, i, j - 1) && maze[i][j-1] != '#'
            push!(tovisit, (d + 1, i, j - 1))
        elseif isin(maze, i, j - 1) && maze[i][j-1] == '#'
            push!(obstaclesfound, (i, j - 1))
        end
    end
    return nothing
end

function getdistance((i, j), (ni, nj))
    return abs(i - ni) + abs(j - nj)
end

function bfs(maze, inii, inij, goali, goalj)
    visited = Set()
    tovisit = [[(inii, inij),],]

    while !isempty(tovisit)
        path = popfirst!(tovisit)

        (i, j) = path[end]
        # print("Visiting $i, $j. From path $path          \n")

        push!(visited, (i, j))

        if i == goali && j == goalj
            return path
        end

        if !((i + 1, j) in visited) && isin(maze, i + 1, j) && maze[i+1][j] != '#'
            # if maze[i+1][j] != '@' || (canuseati, canuseatj) in visited
            newpath = copy(path)
            push!(newpath, (i + 1, j))
            push!(tovisit, newpath)
            # end
        end
        if !((i - 1, j) in visited) && isin(maze, i - 1, j) && maze[i-1][j] != '#'
            # if maze[i-1][j] != '@' || (canuseati, canuseatj) in visited
            newpath = copy(path)
            push!(newpath, (i - 1, j))
            push!(tovisit, newpath)
            # end
        end
        if !((i, j + 1) in visited) && isin(maze, i, j + 1) && maze[i][j+1] != '#'
            # if maze[i][j+1] != '@' || (canuseati, canuseatj) in visited
            newpath = copy(path)
            push!(newpath, (i, j + 1))
            push!(tovisit, newpath)
            # end
        end
        if !((i, j - 1) in visited) && isin(maze, i, j - 1) && maze[i][j-1] != '#'
            # if maze[i][j-1] != '@' || (canuseati, canuseatj) in visited
            newpath = copy(path)
            push!(newpath, (i, j - 1))
            push!(tovisit, newpath)
            # end
        end
    end
    return nothing
end

function popmin!(S::Set)
    if length(S) == 0
        return nothing
    end
    m = minimum(S)
    delete!(S, m)
    return m
end

function part1()
    maze = collect.(getinput())

    inii, inij = findindices2d(maze, 'S')[1]
    goali, goalj = findindices2d(maze, 'E')[1]

    nocheating, obstaclesfound = solvemaze(maze, inii, inij, goali, goalj)

    total = 0
    for (i, j) in obstaclesfound
        # print("Testing position ($i, $j)      \r")
        if maze[i][j] != '#'
            continue
        end

        maze[i][j] = '.'
        s, _ = solvemaze(maze, inii, inij, goali, goalj)

        if s <= nocheating - 100
            total += 1
        end
        maze[i][j] = '#'
    end

    return total
end

function part2()
    maze = collect.(getinput())

    inii, inij = findindices2d(maze, 'S')[1]
    goali, goalj = findindices2d(maze, 'E')[1]

    path = bfs(maze, inii, inij, goali, goalj)

    enpath = collect(enumerate(path))

    total = 0

    for (it, (i, j)) in enpath
        # print("Testing $it              \r")
        for (it2, (i2, j2)) in enpath
            if it2 < it
                continue
            end

            dist = getdistance((i, j), (i2, j2))

            if dist > 20
                continue
            end

            if it + dist + -it2 <= -100
                total += 1
            end
        end
    end

    return total
  
    return length(totalpaths)
end

function main()

    p1 = @time part1()
    p2 = @time part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

