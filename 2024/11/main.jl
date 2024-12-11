include("../utils.jl")

using DataStructures

function getinput()
    return readlines("11/input.in", keep=false)
end

function gettransformation(num, transformationmap=Dict())
    # This does not improve too much the performance (just a mere x5), but it reduces memory usage from 109MiB to 19MiB
    if haskey(transformationmap, num)
        return transformationmap[num]
    end

    if parse(Int, num) == 0
        finalnum = [string('1')]
    elseif length(num) % 2 == 0
        finalnum = [string(parse(Int, num[1:end÷2])), string(parse(Int, num[end÷2+1:end]))]
    else
        finalnum = [string(parse(Int, num) * 2024)]
    end

    transformationmap[num] = finalnum

    return finalnum
end

function blink(stones)
    newstones = String[]

    for stone in stones
        append!(newstones, gettransformation(stone))
    end
    return newstones
end

function smartblink(stonemap, transformationmap)
    newstones = Dict()

    for (stone, value) in stonemap
        created = gettransformation(stone, transformationmap)
        for s in created
            if haskey(newstones, s)
                newstones[s] += value
            else
                newstones[s] = value
            end
        end
    end

    return newstones
end

function part1()
    stones = split(getinput()[1], " ")

    for i in 1:25
        stones = blink(stones)
    end

    return length(stones)
end

function part2()
    stones = counter(split(getinput()[1], " "))
    transformationmap = Dict{String,Vector{String}}()

    for i in 1:75
        stones = smartblink(stones, transformationmap)
    end

    return sum(values(stones))
end

function main()

    p1 = @time part1()
    p2 = @time part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

