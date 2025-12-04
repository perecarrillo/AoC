include("../utils.jl")

function getinput()
    return readlines("4/input.in", keep=false)
end

function part1()
    input = getinput()

    total = 0
    
    for i in 1:length(input)
        for j in 1:length(input[i])
            if input[i][j] == '@'
                sumneigh = 0
                for x in -1:1
                    for y in -1:1
                        if !(x==0 && y==0) && isin(input, i+x, j+y) && input[i+x][j+y] == '@'
                            sumneigh += 1
                        end
                    end
                end
                if sumneigh < 4
                    total += 1
                end
            end
        end
    end

    return total
end

function part2()
    input = map(x->split(x, ""), getinput()::Vector)

    total = 0
    modified = true
    while modified
        modified = false
        for i in 1:length(input)
            for j in 1:length(input[i])
                if input[i][j] == "@"
                    sumneigh = 0
                    for x in -1:1
                        for y in -1:1
                            if !(x==0 && y==0) && isin(input, i+x, j+y) && input[i+x][j+y] == "@"
                                sumneigh += 1
                            end
                        end
                    end
                    if sumneigh < 4
                        total += 1
                        modified = true
                        input[i][j] = "."
                    end
                end
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

