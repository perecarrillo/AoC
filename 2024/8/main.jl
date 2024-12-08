using Combinatorics

include("../utils.jl")

function get_input()
    return readlines("8/input.in", keep=false)
end

function getantennas(map)
    antennas = Dict()
    for (i, line) in enumerate(map)
        for (j, x) in enumerate(line)
            if x != '.'
                if haskey(antennas, x)
                    push!(antennas[x], (i, j))
                else
                    antennas[x] = [(i, j)]
                end
            end
        end
    end
    return antennas
end

function part1()
    input = collect.(get_input())
    
    antennas = getantennas(input)

    antinodes = Set()

    for (freq, ants) in antennas
        combs = combinations(ants, 2)

        for (a1, a2) in combs
            dist = a2 .- a1

            pos1 = a2 .+ dist
            pos2 = a1 .- dist

            if isin(input, pos1)
                push!(antinodes, pos1)
            end
            if isin(input, pos2)
                push!(antinodes, pos2)
            end
        end
    end


    return length(antinodes)
end

function part2()
    input = collect.(get_input())
    
    antennas = getantennas(input)

    antinodes = Set()

    for (freq, ants) in antennas
        combs = combinations(ants, 2)

        for (a1, a2) in combs
            dist::Tuple{Int, Int} = a2 .- a1

            # This is not needed in this specific case, the input is very "nice".
            dist = dist ./ gcd(dist...)

            pos = a1
            oldpos = pos
            
            while isin(input, pos)
                push!(antinodes, pos)
                pos = pos .+ dist
            end

            while isin(input, oldpos)
                push!(antinodes, oldpos)
                oldpos = oldpos .- dist
            end
        end
    end
    return length(antinodes)
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

