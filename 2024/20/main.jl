include("../utils.jl")

using Combinatorics

function getinput()
    return readlines("20/test.in", keep=false)
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

function cheaterbfs(maze, inii, inij, goali, goalj, cheatingi, cheatingj, neighbours, maxpath)
    # println("Starting at $inii, $inij. Can cheat at $cheatingi, $cheatingj")
    tovisit = Set{Tuple}([(1, inii, inij, [(inii, inij)]),])

    paths = Set()

    visited = Dict()

    while !isempty(tovisit)
        d, i, j, path = popmin!(tovisit)
        # print("Exploring $path with a depth of $d          \n")

        if d > maxpath
            continue
        end

        if get(visited, (i, j), 999999999999) < d
            continue
        else
            visited[(i, j)] = d
        end
        if i == goali && j == goalj
            if length(path) < maxpath
                push!(paths, path)
            else
                return length(paths)
            end
        elseif i == cheatingi && j == cheatingj
            for (ni, nj) in neighbours
                if !((ni, nj) in keys(visited))
                    # println("Pushing ($ni, $nj) at a distance of $(d + getdistance((i, j), (ni, nj)))")
                    push!(tovisit, (d + getdistance((i, j), (ni, nj)), ni, nj, vcat(path, (ni, nj))))
                end
            end
        elseif maze[i][j] != '#'
            push!(tovisit, (d + 1, i + 1, j, vcat(path, (i + 1, j))))
            push!(tovisit, (d + 1, i - 1, j, vcat(path, (i - 1, j))))
            push!(tovisit, (d + 1, i, j - 1, vcat(path, (i, j - 1))))
            push!(tovisit, (d + 1, i, j + 1, vcat(path, (i, j + 1))))
        end
    end

    println("Paths found:")
    println.(paths)

    return length(paths)
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

function incircle((circlei, circlej), radius, (i, j))
    # println("Checking distance from ($circlei, $circlej) to ($i, $j). Distance = $((i - circlei) * (i - circlei) + (j - circlej) * (j - circlej)) vs radius = $(radius * radius)")
    # return (i - circlei) * (i - circlei) + (j - circlej) * (j - circlej) <= radius * radius
    return abs(i - circlei) + abs(j - circlej) <= radius
end

function circlepoints((circlei, circlej), radius, minposi, minposj, maxposi, maxposj)
    mini = max(circlei - radius, minposi)
    maxi = min(circlei + radius, maxposi)

    minj = max(circlej - radius, minposj)
    maxj = min(circlej + radius, maxposj)

    points = Set()
    for ii = mini:maxi
        for jj = minj:maxj
            if incircle((circlei, circlej), radius, (ii, jj))
                push!(points, (ii, jj))
            end
        end
    end

    return points
end

function part1()
    maze = collect.(getinput())

    inii, inij = findindices2d(maze, 'S')[1]
    goali, goalj = findindices2d(maze, 'E')[1]

    nocheating, obstaclesfound = solvemaze(maze, inii, inij, goali, goalj)

    total = 0
    for (i, j) in obstaclesfound
        print("Testing position ($i, $j)      \r")
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

    nocheating = length(path)

    println("Max path length: $nocheating")

    total = 0
    for (i, j) in path[1:end-1]
        # i = j = 8
        print("Testing position ($i, $j)              \n")

        # newmaze = deepcopy(maze)
        cpoints = circlepoints((i, j), 6, 2, 2, length(maze) - 1, length(maze[1]) - 1)

        # for (ci, cj) in cpoints
        #     if newmaze[ci][cj] == '#'
        #         newmaze[ci][cj] = '.'
        #     end
        # end

        # println.(newmaze)

        println(cpoints)
        s = cheaterbfs(maze, inii, inij, goali, goalj, i, j, cpoints, nocheating - 74)

        total += s

        # println()
        # println(s)

        # # if length(s) <= nocheating - 50
        # #     total += 1
        # # end
        break
    end

    return total
end

function main()

    # p1 = @time part1()
    p2 = @time part2()

    # println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

