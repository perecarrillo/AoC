using Combinatorics

include("../utils.jl")

function get_input()
    return readlines("8/input.in", keep=false)
end

function part1()
    input = collect.(get_input())
    
    antennas = Dict()
    for (i, line) in enumerate(input)
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

    rows = length(input)
    cols = length(input[1])

    antinodes = 0

    antinodespositions = Set()

    for (freq, ants) in antennas
        combs = combinations(ants, 2)

        for ((i1, j1), (i2, j2)) in combs
            if i1 != i2 || j1 != j2
                disti = i2 - i1
                distj = j2 - j1

                pos1 = (i2 + disti, j2 + distj)
                pos2 = (i1 - disti, j1 - distj)

                if pos1[1] > 0 && pos1[1] <= rows && pos1[2] > 0 && pos1[2] <= cols && !(pos1 in antinodespositions)
                    push!(antinodespositions, pos1)
                    # println("Found antinode in $(pos1[1]), $(pos1[2])")
                    antinodes +=1
                end
                if pos2[1] > 0 && pos2[1] <= rows && pos2[2] > 0 && pos2[2] <= cols && !(pos2 in antinodespositions)
                    push!(antinodespositions, pos2)
                    # println("Found antinode in $(pos2[1]), $(pos2[2])")
                    antinodes +=1
                end
            end
        end
    end


    return antinodes
end

function part2()
    input = collect.(get_input())
    
    antennas = Dict()
    for (i, line) in enumerate(input)
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

    rows = length(input)
    cols = length(input[1])

    antinodes = 0

    antinodespositions = Set()

    for (freq, ants) in antennas
        combs = combinations(ants, 2)

        for ((i1, j1), (i2, j2)) in combs
            if i1 != i2 || j1 != j2
                disti = i2 - i1
                distj = j2 - j1

                g = gcd(disti, distj)

                disti /= g
                distj /= g

                pos1 = (i1, j1)
                oldpos1 = pos1
                
                while pos1[1] > 0 && pos1[1] <= rows && pos1[2] > 0 && pos1[2] <= cols
                    if !(pos1 in antinodespositions)
                        push!(antinodespositions, pos1)
                        # println("Found antinode in $(pos1[1]), $(pos1[2])")
                        antinodes +=1
                    end
                    pos1 = (pos1[1] + disti, pos1[2] + distj)
                end
                pos1 = oldpos1
                while pos1[1] > 0 && pos1[1] <= rows && pos1[2] > 0 && pos1[2] <= cols
                    if !(pos1 in antinodespositions)
                        push!(antinodespositions, pos1)
                        # println("Found antinode in $(pos1[1]), $(pos1[2])")
                        antinodes +=1
                    end
                    pos1 = (pos1[1] - disti, pos1[2] - distj)
                end
            end
        end
    end
    return antinodes
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

