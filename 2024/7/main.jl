include("../utils.jl")

function get_input()
    return readlines("7/input.in", keep=false)
end

function isvalid(test, ops, withcat = false)

    # println("Testing $test, with $ops")
    
    if length(ops) == 1 && ops[1] == test
        return true
    elseif length(ops) == 1 || isempty(ops)
        return false
    end
    
    next = popfirst!(ops)

    sumops = deepcopy(ops)
    sumops[begin] = sumops[begin] + next

    mulops = deepcopy(ops)
    mulops[begin] = mulops[begin] * next

    catops = deepcopy(ops)
    catops[begin] = parse(Int, "$next$(catops[begin])")

    return isvalid(test, sumops, withcat) || isvalid(test, mulops, withcat) || (withcat && isvalid(test, catops, withcat))
end

function part1()
    input = get_input()
    
    total = 0
    for line in input
        test, ops = split(line, ':')
        test = parse(Int, test)
        ops = parse.(Int, split(strip(ops), ' '))

        if isvalid(test, ops)
            total += test
        end
    end

    return total
end

function part2()
    input = get_input()
    
    total = 0
    for line in input
        test, ops = split(line, ':')
        test = parse(Int, test)
        ops = parse.(Int, split(strip(ops), ' '))

        if isvalid(test, ops, true)
            total += test
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

