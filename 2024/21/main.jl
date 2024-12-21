include("../utils.jl")

using Combinatorics

function getinput()
    return readlines("21/input.in", keep=false)
end

@enum Directions begin
    up = 0
    right = 1
    down = 2
    left = 3
    none = 4
end

function popmin!(S)
    if length(S) == 0
        return nothing
    end
    (m, i) = findmin(x -> length(x), S)
    m = S[i]
    deleteat!(S, i)
    return m
end

function bfs(maze, inii, inij, goali, goalj)
    visited = Set()
    tovisit = [[(inii, inij, none),],]

    paths = []

    minpath = -1

    while !isempty(tovisit)
        # println(tovisit)
        path = popmin!(tovisit)

        # println(path)


        (i, j, _) = path[end]
        d = length(path)
        # println("Exploring a depth of $d")

        # push!(visited, (i, j))

        if i == goali && j == goalj
            if minpath == -1 || d == minpath
                minpath = d
                push!(paths, path)
                continue
            else
                return paths
            end
        end

        if !((i + 1, j) in map(x -> (x[1], x[2]), path)) && isin(maze, i + 1, j) && maze[i+1][j] != '#'
            newpath = copy(path)
            push!(newpath, (i + 1, j, down))
            push!(tovisit, newpath)
        end
        if !((i - 1, j) in map(x -> (x[1], x[2]), path)) && isin(maze, i - 1, j) && maze[i-1][j] != '#'
            newpath = copy(path)
            push!(newpath, (i - 1, j, up))
            push!(tovisit, newpath)
        end
        if !((i, j + 1) in map(x -> (x[1], x[2]), path)) && isin(maze, i, j + 1) && maze[i][j+1] != '#'
            newpath = copy(path)
            push!(newpath, (i, j + 1, right))
            push!(tovisit, newpath)
        end
        if !((i, j - 1) in map(x -> (x[1], x[2]), path)) && isin(maze, i, j - 1) && maze[i][j-1] != '#'
            newpath = copy(path)
            push!(newpath, (i, j - 1, left))
            push!(tovisit, newpath)
        end
    end
    return paths
end

numpad = [['7', '8', '9'], ['4', '5', '6'], ['1', '2', '3'], ['#', '0', 'A']]
numpadindices = Dict('7' => (1, 1), '8' => (1, 2), '9' => (1, 3), '4' => (2, 1), '5' => (2, 2), '6' => (2, 3), '1' => (3, 1), '2' => (3, 2), '3' => (3, 3), '0' => (4, 2), 'A' => (4, 3))
keypad = [['#', '^', 'A'], ['<', 'v', '>']]
keypadindices = Dict('^' => (1, 2), 'A' => (1, 3), '<' => (2, 1), 'v' => (2, 2), '>' => (2, 3))
conversion = Dict(up => '^', down => 'v', left => '<', right => '>')

cache = Dict()

function getmaxlength(depth::Int, from::Char, to::Char, usenumpad::Bool, maxdepth::Int)
    if haskey(cache, (depth, from, to, usenumpad, maxdepth))
        return cache[(depth, from, to, usenumpad, maxdepth)]
    end

    if usenumpad
        maze = numpad
        indices = numpadindices
    else
        maze = keypad
        indices = keypadindices
    end

    possiblepaths = map(path -> [map(x -> conversion[x[3]], path[2:end]); 'A'], bfs(maze, indices[from]..., indices[to]...))

    if depth == maxdepth
        cache[(depth, from, to, usenumpad, maxdepth)] = length(possiblepaths[1])
        return length(possiblepaths[1])
    end

    minlen = Inf
    for path in possiblepaths
        pathlen = 0
        initial = 'A'
        for c in path
            l = getmaxlength(depth + 1, initial, c, false, maxdepth)
            pathlen += l
            initial = c
        end
        minlen = min(minlen, pathlen)
    end
    cache[(depth, from, to, usenumpad, maxdepth)] = Int(minlen)
    return Int(minlen)
end

function part1(maxdepth=3)
    input = collect.(getinput())


    total = 0
    for line in input
        totallength = 0
        initial = 'A'
        for c in line
            l = getmaxlength(1, initial, c, true, maxdepth)
            totallength += l
            initial = c
        end

        n = parse(Int, string(line[1:end-1]...))
        # println(n)

        # println("Partial result: p: $totallength, n: $n")
        total += totallength * n
    end

    return total
end

function part2()
    return part1(26)
end

function main()

    p1 = @time part1()
    p2 = @time part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

