include("../utils.jl")

using JuMP
import HiGHS, Cbc
using Formatting


function getinput()
    return readlines("13/input.in", keep=false)
end

function part1()
    input = getinput()

    problems = splitby(==(""), input)

    total::Int = 0

    for problem in problems
        X = parse(Int, split(split(problem[3], ',')[1], '=')[end])
        Y = parse(Int, split(split(problem[3], ',')[end], '=')[end])

        Ax = parse(Int, problem[1][13:14])
        Ay = parse(Int, problem[1][19:20])
        Bx = parse(Int, problem[2][13:14])
        By = parse(Int, problem[2][19:20])

        # println("X: $X, Y: $Y, Ax: $Ax, Ay: $Ay")


        model = Model(HiGHS.Optimizer)
        set_silent(model)
        @variable(model, pA >= 0, Int)
        @variable(model, pB >= 0, Int)

        @constraint(model, X == pA * Ax + pB * Bx)
        @constraint(model, Y == pA * Ay + pB * By)

        @objective(model, Min, 3 * pA + pB)

        optimize!(model)

        # println(termination_status(model))

        # println("pA: $(value(pA)), pB: $(value(pB))")

        if termination_status(model) == OPTIMAL
            total += value(pA) * 3 + value(pB)
        end

    end

    return total
end

function part2()
    input = getinput()

    problems = splitby(==(""), input)

    total::BigInt = 0

    for problem in problems
        X = parse(Int, split(split(problem[3], ',')[1], '=')[end]) + 10000000000000
        Y = parse(Int, split(split(problem[3], ',')[end], '=')[end]) + 10000000000000

        Ax = parse(Int, problem[1][13:14])
        Ay = parse(Int, problem[1][19:20])
        Bx = parse(Int, problem[2][13:14])
        By = parse(Int, problem[2][19:20])

        # println("X: $X, Y: $Y, Ax: $Ax, Ay: $Ay")
        # println("Button A: X+$Ax, Y+$Ay")
        # println("Button B: X+$Bx, Y+$By")
        # println("Prize: X=$(X), Y=$(Y)")



        model = Model(Cbc.Optimizer)
        set_attribute(model, "logLevel", 0)
        # set_silent(model)
        @variable(model, pA >= 0, Int)
        @variable(model, pB >= 0, Int)

        @constraint(model, X == (pA * Ax) + (pB * Bx))
        @constraint(model, Y == (pA * Ay) + (pB * By))

        @objective(model, Min, (3 * pA) + pB)

        optimize!(model)

        println(termination_status(model))

        if termination_status(model) == OPTIMAL
            println("pA: $(format(value(pA))), pB: $(format(value(pB)))")
            newpA = round(Int, value(pA))
            newpB = round(Int, value(pB))
            println("Real pA: $(format(value(newpA))), pB: $(format(value(newpB)))")
            total += newpA * 3 + newpB
            # println("rhs: $(value(pA) * Ax + value(pB) * Bx), lhs: $(X)")
            @assert(newpA * Ax + newpB * Bx == X)
            @assert(newpA * Ay + newpB * By == Y)
        else
            # @assert(newpA * Ax + newpB * Bx != X || newpA * Ay + newpB * By != Y, "Solution did exist: $newpA, $newpB")
        end

        println()
        # println()

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

