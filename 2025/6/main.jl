include("../utils.jl")

function getinput()
    return readlines("6/input.in", keep=false)
end

function part1()
    input = getinput()

    nums = map(x -> parse.(Int, split(x, " ", keepempty=false)), input[1:4])
    ops = split(input[5]," ", keepempty=false)

    total = 0
    
    for i in 1:length(ops)
        if ops[i] == "+"
            total += foldl(+, getindex.(nums, i), init=0)
        elseif ops[i] == "*"
            total += foldl(*, getindex.(nums, i), init=1)
        end
    end

    return total
end

function part2()
    input = reverse.(getinput())

    nums = map(x -> split(x, "", keepempty=true), input[1:4])
    ops = split(input[5],"", keepempty=true)

    total = 0
    
    prevnums = []

    for i in 1:length(ops)
        newnum = strip(foldl(*, getindex.(nums, i)))
        if newnum != ""
            push!(prevnums, parse(Int, newnum))
        end

        if ops[i] == "+"
            total += foldl(+, prevnums, init=0)
            prevnums = []
        elseif ops[i] == "*"
            total += foldl(*, prevnums, init=1)
            prevnums = []
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

