include("../utils.jl")

using JuMP, SCIP



function getinput()
    return readlines("13/input.in", keep=false)
end

function part1(;increment = 0)
    input = getinput()

    problems = splitby(==(""), input)

    total::Int = 0

    for problem in problems
        X = parse(Int, split(split(problem[3], ',')[1], '=')[end]) + increment
        Y = parse(Int, split(split(problem[3], ',')[end], '=')[end]) + increment

        Ax = parse(Int, problem[1][13:14])
        Ay = parse(Int, problem[1][19:20])
        Bx = parse(Int, problem[2][13:14])
        By = parse(Int, problem[2][19:20])

        model = Model(SCIP.Optimizer)
        set_attribute(model, "display/verblevel", 0)

        @variable(model, pA >= 0, Int)
        @variable(model, pB >= 0, Int)

        @constraint(model, X == pA * Ax + pB * Bx)
        @constraint(model, Y == pA * Ay + pB * By)

        @objective(model, Min, 3 * pA + pB)

        optimize!(model)

        if termination_status(model) == OPTIMAL
            total += value(pA) * 3 + value(pB)
        end

    end
    return total
end

function main()

    p1 = @time part1()
    p2 = @time part1(increment=10000000000000)

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

