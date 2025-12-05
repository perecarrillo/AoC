include("../utils.jl")

function getinput()
    return readlines("5/input.in", keep=false)
end

function part1()
    ranges, ingredients = splitby(==(""), getinput())

    ranges = map(x->parse.(Int, split(x, "-")), ranges)
    ingredients = parse.(Int, ingredients)

    freshs = 0
    
    for ing in ingredients
        for (min,max) in ranges
            if ing >= min && ing <= max
                freshs += 1
                break
            end
        end
    end

    return freshs
end

function removerange(ranges::Vector{Vector{Int}}, range::Vector{Int})::Vector{Vector{Int}}
    # No se pq el filter no filterea i no veig lerror aixi que toca ferho manual :(
    # return filter((min, max)->min==range[1] && max==range[2], ranges)

    swapnpop!(ranges, findfirst(==(range), ranges)) # Slightly faster deleteat!
    
    return ranges
end

function addrange(ranges::Vector{Vector{Int}}, newrange::Vector{Int})::Vector{Vector{Int}}
    newmin, newmax = newrange
    # println("Adding new range: $newrange")
    for range in ranges
        # println("---> Testing with $range")

        # Min inside range
        if newmin >= range[1] && newmin <= range[2]+1 # +1 to merge consecutive ranges for easier debugging :)
            # println("------> Min is inside the range, changing max")
            if newmax >= range[2]
                range[2] = newmax
            end
            # This new range can overlap with other existing ranges, so we delete it and add it again
            return addrange(removerange(ranges, range), range)
        end
        
        # Max inside range
        if newmax >= range[1]-1 && newmax <= range[2] # -1 to merge consecutive ranges
            # println("------> Max is inside the range, changing min")
            if newmin <= range[1]
                range[1] = newmin
            end
            return addrange(removerange(ranges, range), range)
        end

        # Old range inside new range
        if newmin <= range[1] && newmax >= range[2]
            range[1] = newmin
            range[2] = newmax

            return addrange(removerange(ranges, range), range)
        end
    end
    # println("---> Not overlapping, adding it")
    push!(ranges, newrange)

    return ranges
end

function part2()
    ranges, _ = splitby(==(""), getinput())

    ranges = map(x->parse.(Int, split(x, "-")), ranges)

    nonoverlapingranges = foldl(addrange, ranges, init=Vector{Vector{Int}}())

    # println(sort(nonoverlapingranges, by=x->x[1]))

    return foldl((sum, (min, max))-> sum += max-min+1, nonoverlapingranges, init=0)
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

