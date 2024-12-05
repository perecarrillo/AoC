include("../utils.jl")

function get_input()
    return readlines("5/input.in", keep=false)
end

struct PagesOrdering <: Base.Order.Ordering
    rules::Dict
end

import Base.Order.lt
lt(o::PagesOrdering, a, b) = !haskey(o.rules, a) || !insorted(b, o.rules[a])

function get_rules(rules_raw::Vector)
    rules = Dict()
    for line in rules_raw
        precondition, key = parse.(Int, split(line, "|"))

        if haskey(rules, key)
            append!(rules[key], precondition)
        else
            rules[key] = [precondition]
        end
    end
    for (_, val) in rules
        sort!(val)
    end
    return rules
end

function part1()
    input = get_input()

    rules_raw, updates = splitby(==(""), input)

    rules = get_rules(rules_raw)

    return sum(l -> l[end÷2+1], filter(update -> issorted(update, order=PagesOrdering(rules)), map(x -> parse.(Int, split(x, ",")), updates)))
end

function part2()
    input = get_input()

    rules_raw, updates = splitby(==(""), input)

    rules = get_rules(rules_raw)

    unsortedsorted = sort!.(filter(update -> !issorted(update, order=PagesOrdering(rules)), map(x -> parse.(Int, split(x, ",")), updates)), order=PagesOrdering(rules))

    return sum(l -> l[end÷2+1], unsortedsorted)
end

function main()

    p1 = part1()
    p2 = part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

