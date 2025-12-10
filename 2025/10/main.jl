include("../utils.jl")

using JuMP, SCIP

function getinput()
    return readlines("10/input.in", keep=false)
end

function buttonscontaininglight(lightidx, buttons)
    return eachindex(buttons) |> filter(i->contains(buttons[i], "$(lightidx-1)")) |> collect
end

function part1()
    input = split.(getinput(), " ")

    totalpresses = 0

    for (lights, buttons..., joltage) in input
        # println("Lights: $lights ($(length(lights)))")
        # println("Buttons: $buttons")

        lights = strip(lights, ['[',']'])

        model = Model(SCIP.Optimizer)
        set_attribute(model, "display/verblevel", 0)

        @variable(model, p[1:length(buttons)], Bin)
        @variable(model, k[1:length(lights)], Int)

        for i in eachindex(lights)
            @constraint(model, sum(p[buttonscontaininglight(i, buttons)]) == 2k[i] + (lights[i]=='#' ? 1 : 0))
        end

        # println(p)
        # println(k)
        # println(all_constraints(model; include_variable_in_set_constraints = true))

        @objective(model, Min, sum(p))

        optimize!(model)

        if termination_status(model) == OPTIMAL
            totalpresses += sum(value(p))
        else
            throw("Unsolvable")
        end

    end
    return totalpresses
end

function part2()
    input = split.(getinput(), " ")

    totalpresses = 0

    for (lights, buttons..., joltages) in input
        lights = strip(lights, ['[',']'])
        joltages = parse.(Int, split(strip(joltages, ['{', '}']), ","))

        model = Model(SCIP.Optimizer)
        set_attribute(model, "display/verblevel", 0)

        @variable(model, p[1:length(buttons)], Int)
    
        @constraint(model, p[1:length(buttons)] .>= 0)

        for i in eachindex(joltages)
            @constraint(model, sum(p[buttonscontaininglight(i, buttons)]) == joltages[i])
        end

        @objective(model, Min, sum(p))

        optimize!(model)

        if termination_status(model) == OPTIMAL
            totalpresses += sum(value(p))
        else
            throw("Unsolvable")
        end

    end
    return totalpresses
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

