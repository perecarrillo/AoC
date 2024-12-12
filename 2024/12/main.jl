include("../utils.jl")
using OrderedCollections

function getinput()
    return readlines("12/input.in", keep=false)
end

@enum Sides begin
    top = 1
    right = 2
    bottom = 3
    left = 4
end

function findareaandperimeter(garden, i, j, key, visited)
    if (i, j) in visited || garden[i][j] != key
        return 0, 0, Set()
    end

    push!(visited, (i, j))

    sides = Set()
    area = 1
    perimeter = 0
    if isin(garden, i - 1, j) && garden[i-1][j] == key
        newarea, newper, sid = findareaandperimeter(garden, i - 1, j, key, visited)

        area += newarea
        perimeter += newper
        union!(sides, sid)
    else
        perimeter += 1
        push!(sides, (i, j, top))
    end
    if isin(garden, i + 1, j) && garden[i+1][j] == key
        newarea, newper, sid = findareaandperimeter(garden, i + 1, j, key, visited)

        area += newarea
        perimeter += newper
        union!(sides, sid)
    else
        perimeter += 1
        push!(sides, (i, j, bottom))
    end
    if isin(garden, i, j - 1) && garden[i][j-1] == key
        newarea, newper, sid = findareaandperimeter(garden, i, j - 1, key, visited)

        area += newarea
        perimeter += newper
        union!(sides, sid)
    else
        perimeter += 1
        push!(sides, (i, j, left))
    end
    if isin(garden, i, j + 1) && garden[i][j+1] == key
        newarea, newper, sid = findareaandperimeter(garden, i, j + 1, key, visited)

        area += newarea
        perimeter += newper
        union!(sides, sid)
    else
        perimeter += 1
        push!(sides, (i, j, right))
    end

    return area, perimeter, sides
end

function computesides(sides)
    prevres = Set()
    newres = _computesides(sides)

    while prevres != newres
        prevres = newres
        newres = _computesides(newres)
    end

    return newres
end

function _computesides(sides)
    realsides = Set()
    computedsides = Set()
    for side in sides
        if side in computedsides
            continue
        end
        (i, j, s) = side
        push!(computedsides, side)

        if s == left && !((i - 1, j, left) in computedsides || (i + 1, j, left) in computedsides)
            push!(realsides, side)
        elseif s == right && !((i - 1, j, right) in computedsides || (i + 1, j, right) in computedsides)
            push!(realsides, side)
        elseif s == top && !((i, j - 1, top) in computedsides || (i, j + 1, top) in computedsides)
            push!(realsides, side)
        elseif s == bottom && !((i, j - 1, bottom) in computedsides || (i, j + 1, bottom) in computedsides)
            push!(realsides, side)
        end
        # ...so the fence does not connect across the middle of the region (where the two B regions touch diagonally)... mimimi

        # if s == left && !((i - 1, j, left) in computedsides || (i - 1, j - 1, right) in computedsides || (i + 1, j, left) in computedsides || (i + 1, j - 1, right) in computedsides)
        #     push!(realsides, side)
        # elseif s == right && !((i - 1, j, right) in computedsides || (i - 1, j + 1, left) in computedsides || (i + 1, j, right) in computedsides || (i + 1, j + 1, left) in computedsides)
        #     push!(realsides, side)
        # elseif s == top && !((i, j - 1, top) in computedsides || (i - 1, j - 1, bottom) in computedsides || (i, j + 1, top) in computedsides || (i - 1, j + 1, bottom) in computedsides)
        #     push!(realsides, side)
        # elseif s == bottom && !((i, j - 1, bottom) in computedsides || (i + 1, j - 1, top) in computedsides || (i, j + 1, bottom) in computedsides || (i + 1, j + 1, top) in computedsides)
        #     push!(realsides, side)
        # end
    end
    return realsides
end

function part1()
    input = collect.(getinput())

    total = 0
    visited = Set()
    for i in 1:length(input)
        for j in 1:length(input[i])
            if !((i, j) in visited)
                area, per, _ = findareaandperimeter(input, i, j, input[i][j], visited)
                total += area * per
            end
        end
    end

    return total
end

function part2()
    input = collect.(getinput())

    total = 0
    visited = Set()
    for i in 1:length(input)
        for j in 1:length(input[i])
            if !((i, j) in visited)
                area, per, sides = findareaandperimeter(input, i, j, input[i][j], visited)
                sides = sort(collect(sides))
                sides = OrderedSet{Tuple}(sides)

                # println("Sides before pruning: $sides (of perimeter $per)\n")
                totalsides = computesides(sides)
                # println("Sides after pruning: $totalsides (of size $(length(totalsides)) and area $area)\n")

                total += area * length(totalsides)
            end
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

