include("../utils.jl")

function getinput()
    return readlines("7/input.in", keep=false)
end

function part1()
    input = getinput()
    input = map(x -> split(x, "", keepempty=true), input)
    replace!(input[1], "S" => "|")

    totalsplits = 0
    
    for (i, line) in enumerate(input)
        if i == 1
            continue
        end
        for (j, char) in enumerate(line)
            upchar = input[i-1][j]
            if upchar == "|"
                if char == "."
                    line[j] = "|"
                elseif char == "^"
                    totalsplits += 1
                    if line[j-1] == "."
                        line[j-1] = "|"
                    end
                    if line[j+1] == "."
                        line[j+1] = "|"
                    end
                end
            end
        end
    end

    return totalsplits
end

function part2()
    input_old = getinput()
    input::Vector{Vector{Union{Char, Int}}} = map(x -> only.(split(x, "", keepempty=true)), input_old)
    replace!(input[1], 'S' => 1)

    for (i, line) in enumerate(input)
        if i == 1
            continue
        end
        splitsused = 0
        for (j, char) in enumerate(line)
            upchar = input[i-1][j]
            if typeof(upchar) == Int
                if typeof(char) == Int
                    line[j] += upchar
                elseif char == '.'
                    line[j] = upchar
                elseif char == '^'
                    splitsused += 1
                    if typeof(line[j-1]) == Int
                        line[j-1] += upchar
                    else
                        line[j-1] = upchar
                    end
                    if typeof(line[j+1]) == Int
                        line[j+1] += upchar
                    else
                        line[j+1] = upchar
                    end
                end
            end
        end
    end

    return foldl((sum, x)->typeof(x) == Int ? sum + x : sum, input[end])
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

