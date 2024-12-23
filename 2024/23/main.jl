
using Combinatorics, ProgressBars, Graphs

include("../utils.jl")

function getinput()
    return readlines("23/input.in", keep=false)
end

function isclique(nodes, adjacencylist)
    for node in nodes
        for node2 in nodes
            if node != node2 && !adjacencylist[node, node2]
                return false
            end
        end
    end
    return true
end

function createadjacencymatrix(input, n, con2int)
    adjacent = fill(false, (n, n))

    for line in input
        c1, c2 = split(line, "-")
        i1 = con2int[c1]
        i2 = con2int[c2]

        adjacent[i1, i2] = true
        adjacent[i2, i1] = true
    end
    return adjacent
end

function gettransformations(input)
    con2int = Dict()
    int2con = Dict()

    i = 1

    for line in input
        c1, c2 = split(line, "-")
        if !haskey(con2int, c1)
            con2int[c1] = i
            int2con[i] = c1
            i += 1
        end
        if !haskey(con2int, c2)
            con2int[c2] = i
            int2con[i] = c2
            i += 1
        end
    end

    return con2int, int2con
end


function part1()
    input = getinput()
    con2int, int2con = gettransformations(input)
    adjacent = createadjacencymatrix(input, length(con2int), con2int)

    # display(adjacent)

    combs = collect(combinations(collect(keys(int2con)), 3))
    filter!(x -> int2con[x[1]][1] == 't' || int2con[x[2]][1] == 't' || int2con[x[3]][1] == 't', combs)

    total = 0
    for comb in combs
        # print(comb, ", ")
        # println(map(x -> int2con[x], comb))
        if isclique(comb, adjacent)
            # println("Found clique!")
            total += 1
        end
    end
    return total
end

function part2()
    input = getinput()
    con2int, int2con = gettransformations(input)

    n = length(con2int)
    adjacent = fill(false, (n, n))

    neighbours = Dict()
    for line in input
        c1, c2 = split(line, "-")
        i1 = con2int[c1]
        i2 = con2int[c2]

        adjacent[i1, i2] = true
        adjacent[i2, i1] = true

        if haskey(neighbours, i1)
            push!(neighbours[i1], i2)
        else
            neighbours[i1] = Set([i2])
        end
        if haskey(neighbours, i2)
            push!(neighbours[i2], i1)
        else
            neighbours[i2] = Set([i1])
        end
    end

    combs = collect(combinations(collect(keys(int2con)), 3))
    filter!(x -> int2con[x[1]][1] == 't' || int2con[x[2]][1] == 't' || int2con[x[3]][1] == 't', combs)

    cliques3 = []
    for comb in combs
        if isclique(comb, adjacent)
            push!(cliques3, Set(comb))
        end
    end

    lastmaxclique = []
    cliques = Set(cliques3)
    while !isempty(cliques)
        println("Searching for cliques of size $(length(first(cliques)) + 1). We have $(length(cliques)) candidates")
        newcliques = Set()

        for clique in ProgressBar(cliques)
            myneigbours = intersect(map(c -> neighbours[c], collect(clique))...)
            for i in myneigbours
                newclique = copy(clique)
                push!(newclique, i)
                # if !in(i, clique) && isclique(newclique, adjacent)
                push!(newcliques, newclique)
                # end
            end
        end
        lastmaxclique = first(cliques)
        cliques = newcliques
    end

    return join(sort(map(x -> int2con[x], collect(lastmaxclique))), ",")
end

function fastpart2()
    input = getinput()
    con2int, int2con = gettransformations(input)
    adjacencymatrix = createadjacencymatrix(input, length(con2int), con2int)

    g = Graph(adjacencymatrix)

    cliques = maximal_cliques(g)
    maxclique = cliques[findmax(length, cliques)[2]]

    return join(sort(map(x -> int2con[x], maxclique)), ",")
end

function main()

    p1 = @time part1()
    p2 = @time part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

