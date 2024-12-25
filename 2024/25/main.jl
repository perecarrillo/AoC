include("../utils.jl")

function getinput()
    return readlines("25/input.in", keep=false)
end

function part1()
    input = getinput()
    input = splitby(==(""), input)

    keys = []
    locks = []

    for rawline in input
        line = collect.(rawline)
        sizes = zeros(Int, (5,))
        for i = 1:7
            for j = 1:5
                if line[i][j] == '#'
                    sizes[j] += 1
                end
            end
        end

        if rawline[1] == "#####"
            # Lock
            push!(locks, sizes)
        else
            # Key
            push!(keys, sizes)
        end
    end

    combs = Iterators.product(keys, locks)

    total = 0

    for (key, lock) in combs
        if all(key .+ lock .<= fill(7, (5,)))
            total += 1
        end
    end

    return total
end

function main()

    p1 = @time part1()

    println("Part 1: $p1")

end

main()

