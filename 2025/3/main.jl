include("../utils.jl")

function getinput()
    return readlines("3/input.in", keep=false)
end

function part1()
    input = getinput()

    sum = 0
    
    for line in input
        max, idx = findmax(x->parse(Int, x), line[begin:end-1])

        maxs, _ = findmax(x->parse(Int, x), line[idx+1:end])

        sum += max*10+maxs
    end

    return sum
end

function part2()
    input = getinput()

    sum = 0
    
    for line in input

        startidx = 0

        for i in 1:12
            max, idx = findmax(x->parse(Int, x), line[startidx+1:end-(12-i)])

            sum += max*10^(12-i)

            startidx = startidx + idx
        end
    end

    return sum
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

