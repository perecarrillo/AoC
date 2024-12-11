include("../utils.jl")

function getinput()
    return readlines("10/input.in", keep=false)
end

function trailsfrom(map, i, j)
    if map[i][j] == '9'
        return [(i, j),]
    end

    total = Set()
    if isin(map, i - 1, j) && map[i-1][j] == map[i][j] + 1
        union!(total, trailsfrom(map, i - 1, j))
    end
    if isin(map, i + 1, j) && map[i+1][j] == map[i][j] + 1
        union!(total, trailsfrom(map, i + 1, j))
    end
    if isin(map, i, j - 1) && map[i][j-1] == map[i][j] + 1
        union!(total, trailsfrom(map, i, j - 1))
    end
    if isin(map, i, j + 1) && map[i][j+1] == map[i][j] + 1
        union!(total, trailsfrom(map, i, j + 1))
    end

    return total
end

function trailsstarting(map, i, j)
    if map[i][j] == '9'
        return 1
    end

    total = 0
    if isin(map, i - 1, j) && map[i-1][j] == map[i][j] + 1
        total += trailsstarting(map, i - 1, j)
    end
    if isin(map, i + 1, j) && map[i+1][j] == map[i][j] + 1
        total += trailsstarting(map, i + 1, j)
    end
    if isin(map, i, j - 1) && map[i][j-1] == map[i][j] + 1
        total += trailsstarting(map, i, j - 1)
    end
    if isin(map, i, j + 1) && map[i][j+1] == map[i][j] + 1
        total += trailsstarting(map, i, j + 1)
    end

    return total
end

function part1()
    input = collect.(getinput())

    total = 0
    for i in 1:length(input)
        for j in 1:length(input[i])
            if input[i][j] == '0'
                total += length(trailsfrom(input, i, j))
            end
        end
    end

    return total
end

function part2()
    input = collect.(getinput())

    total = 0
    for i in 1:length(input)
        for j in 1:length(input[i])
            if input[i][j] == '0'
                total += trailsstarting(input, i, j)
            end
        end
    end

    return total
end

function main()

    p1 = @time part1()
    p2 = @time part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

