include("../utils.jl")

function getinput()
    return readlines("19/input.in", keep=false)
end

issolvable = Dict()

function canbedone(pattern, towels)
    # println("Can $pattern be solved??")
    if haskey(issolvable, pattern)
        return issolvable[pattern]
    end

    combs = 0
    if insorted(pattern, towels)
        combs += 1
    end

    for i = 1:length(pattern)
        if insorted(pattern[1:i], towels)
            combs += canbedone(pattern[i+1:end], towels)
        end
    end

    issolvable[pattern] = combs
    return combs
end

function part1()
    input = getinput()

    towels, patterns = splitby(==(""), input)

    towels = sort(replace.(split(towels[1], ","), " " => ""))
    # println(towels)

    total = 0
    i = 0
    for pattern in patterns
        # println("Checking $pattern ($i)")
        if canbedone(pattern, towels) > 0
            total += 1
        end
        i += 1
    end

    return total
end

function part2()
    input = getinput()

    towels, patterns = splitby(==(""), input)

    towels = sort(replace.(split(towels[1], ","), " " => ""))
    # println(towels)

    total = 0
    i = 0
    for pattern in patterns
        # println("Checking $pattern ($i) ")
        total += canbedone(pattern, towels)
        i += 1
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

