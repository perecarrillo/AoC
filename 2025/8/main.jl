include("../utils.jl")

function getinput()
    return readlines("8/input.in", keep=false)
end

function distance(x, y)
    # return sqrt(sum((x.-y).^2))
    return sum(x->x^2, (x.-y))
end

function part1()
    input = map(x->parse.(Int, split(x, ",")), getinput())

    distances::Vector{Tuple{Int, Int, Int}} = [i==j ? missing : (i, j, distance(input[i], input[j])) for i in eachindex(input) for j in i:length(input)] |> skipmissing |> collect

    sort!(distances, by=x->x[3])

    circuits::Vector{Set{Int}} = []
    
    for (i, j, dist) in distances[1:1000]
        iincircuit = foldl((circfound, (circid, circ))-> i in circ ? circid : circfound, enumerate(circuits), init=-1)
        jincircuit = foldl((circfound, (circid, circ))-> j in circ ? circid : circfound, enumerate(circuits), init=-1)

        if iincircuit == -1 && jincircuit == -1
            push!(circuits, Set([i, j]))
        elseif iincircuit == -1
            push!(circuits[jincircuit], i)
        elseif jincircuit == -1
            push!(circuits[iincircuit], j)
        elseif iincircuit != jincircuit
            # Both in a different circuit
            push!(circuits[iincircuit], circuits[jincircuit]...)
            swapnpop!(circuits, jincircuit)
        end
    end

    return prod(sort(map(x->length(x), circuits), rev=true)[1:3])
end

function part2()
    input = map(x->parse.(Int, split(x, ",")), getinput())

    distances::Vector{Tuple{Int, Int, Int}} = [i==j ? missing : (i, j, distance(input[i], input[j])) for i in eachindex(input) for j in i:length(input)] |> skipmissing |> collect

    sort!(distances, by=x->x[3])

    circuits::Vector{Set{Int}} = []

    idx = 1

    while !(length(circuits) == 1 && length(circuits[1]) == length(input))
        i,j,_ = distances[idx]
        iincircuit = foldl((circfound, (circid, circ))-> i in circ ? circid : circfound, enumerate(circuits), init=-1)
        jincircuit = foldl((circfound, (circid, circ))-> j in circ ? circid : circfound, enumerate(circuits), init=-1)
    
        if iincircuit == -1 && jincircuit == -1
            push!(circuits, Set([i, j]))
        elseif iincircuit == -1
            push!(circuits[jincircuit], i)
        elseif jincircuit == -1
            push!(circuits[iincircuit], j)
        elseif iincircuit != jincircuit
            # Both in a different circuit
            push!(circuits[iincircuit], circuits[jincircuit]...)
            swapnpop!(circuits, jincircuit)
        end

        idx += 1
    end

    return input[distances[idx-1][1]][1] * input[distances[idx-1][2]][1]
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

