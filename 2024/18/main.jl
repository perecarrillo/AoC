include("../utils.jl")

function getinput()
    return readlines("18/input.in", keep=false)
end

function solvemaze(maze, inii, inij, goali, goalj)
    visited = Set()
    tovisit = Set([(0, inii, inij),])

    while !isempty(tovisit)
        d, i, j = popmin!(tovisit)

        if (i, j) in visited
            continue
        end
        push!(visited, (i, j))

        if i == goali && j == goalj
            return d
        end

        if isin(maze, i + 1, j) && maze[i+1, j] == '.'
            push!(tovisit, (d + 1, i + 1, j))
        end
        if isin(maze, i - 1, j) && maze[i-1, j] == '.'
            push!(tovisit, (d + 1, i - 1, j))
        end
        if isin(maze, i, j + 1) && maze[i, j+1] == '.'
            push!(tovisit, (d + 1, i, j + 1))
        end
        if isin(maze, i, j - 1) && maze[i, j-1] == '.'
            push!(tovisit, (d + 1, i, j - 1))
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
    input = getinput()

    maxi = maxj = 71
    maze = fill('.', (maxi, maxj))

    m = min(1024, length(input))
    for i in 1:m
        x, y = parse.(Int, split(input[i], ","))
        maze[y+1, x+1] = '#'
    end

    return solvemaze(maze, 1, 1, maxi, maxj)

end

function part2()
    input = getinput()

    maxi = maxj = 71
    maze = fill('.', (maxi, maxj))

    for (i, line) in enumerate(input)
        x, y = parse.(Int, split(line, ","))
        maze[y+1, x+1] = '#'

        res = solvemaze(maze, 1, 1, maxi, maxj)

        if isnothing(res)
            return "$x,$y"
        end
    end

end

function main()

    p1 = @time part1()
    p2 = @time part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

