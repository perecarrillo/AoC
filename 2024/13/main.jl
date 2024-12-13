include("../utils.jl")

using JuMP
import HiGHS
using Formatting
using PyCall

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

py"""
from scipy.optimize import milp, LinearConstraint
import numpy as np

def solveProblem(X, Y, Ax, Ay, Bx, By):
    c = [3, 1]
    A = [[Ax, Bx], [Ay, By]]
    b = [X, Y]

    constraints = LinearConstraint(A, b, b)

    res = milp(integrality=[1, 1], constraints=constraints, c=c)

    return res.success, res.x
"""

function part2()
    input = getinput()

    problems = splitby(==(""), input)

    foreach(x -> println.(x);println(), problems)

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

        success, x = py"solveProblem"(X, Y, Ax, Ay, Bx, By)

        if success
            pA::BigInt, pB::BigInt = x

            println("Found solution: $pA, $pB")

            total += 3*pA + pB
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

