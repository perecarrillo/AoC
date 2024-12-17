include("../utils.jl")

function getinput()
    return readlines("16/input.in", keep=false)
end

function popmin!(S::Set)
    if length(S) == 0
        return nothing
    end
    m = minimum(S)
    delete!(S, m)
    return m
end

@enum Direction begin
    up = 0
    down = 1
    left = 2
    right = 3
end

function part1()
    input = collect.(getinput())

    i, j = findindices2d(input, 'S')[1]

    visited = Set{Tuple}()
    tovisit = Set{Tuple}([(0, i, j, left),])

    while !isempty(tovisit)
        d, i, j, dir = popmin!(tovisit)
        if (i, j, dir) in visited
            continue
        else
            push!(visited, (i, j, dir))
        end
        if input[i][j] == 'E'
            return d
        elseif input[i][j] != '#'
            if dir == up
                push!(tovisit, (d + 1, i - 1, j, up))
                push!(tovisit, (d + 1001, i, j - 1, left))
                push!(tovisit, (d + 1001, i, j + 1, right))
            elseif dir == down
                push!(tovisit, (d + 1001, i, j - 1, left))
                push!(tovisit, (d + 1001, i, j + 1, right))
                push!(tovisit, (d + 1, i + 1, j, down))
            elseif dir == left
                push!(tovisit, (d + 1001, i - 1, j, up))
                push!(tovisit, (d + 1, i, j - 1, left))
                push!(tovisit, (d + 1001, i + 1, j, down))
            else
                push!(tovisit, (d + 1001, i - 1, j, up))
                push!(tovisit, (d + 1, i, j + 1, right))
                push!(tovisit, (d + 1001, i + 1, j, down))
            end
        end
    end
    error("No path found")
end

function part2()
    input = collect.(getinput())

    i, j = findindices2d(input, 'S')[1]

    p1 = part1()

    minpath = -1
    totaltiles = Set{Tuple}()
    tovisit = Set{Tuple}([(0, i, j, left, [(i, j)]),])

    visited = Dict()

    while !isempty(tovisit)
        d, i, j, dir, path = popmin!(tovisit)
        print("Exploring $i, $j with a depth of $d          \r")

        if d > p1
            continue
        end

        if get(visited, (i, j, dir), 999999999999) < d
            continue
        else
            visited[(i, j, dir)] = d
        end
        if input[i][j] == 'E'
            if minpath == -1 || length(path) == minpath
                minpath = length(path)
                foreach(x -> push!(totaltiles, x), path)
            else
                return length(totaltiles)
            end
        elseif input[i][j] != '#'
            if dir == up
                push!(tovisit, (d + 1, i - 1, j, up, vcat(path, (i - 1, j))))
                push!(tovisit, (d + 1001, i, j - 1, left, vcat(path, (i, j - 1))))
                push!(tovisit, (d + 1001, i, j + 1, right, vcat(path, (i, j + 1))))
            elseif dir == down
                push!(tovisit, (d + 1001, i, j - 1, left, vcat(path, (i, j - 1))))
                push!(tovisit, (d + 1001, i, j + 1, right, vcat(path, (i, j + 1))))
                push!(tovisit, (d + 1, i + 1, j, down, vcat(path, (i + 1, j))))
            elseif dir == left
                push!(tovisit, (d + 1001, i - 1, j, up, vcat(path, (i - 1, j))))
                push!(tovisit, (d + 1, i, j - 1, left, vcat(path, (i, j - 1))))
                push!(tovisit, (d + 1001, i + 1, j, down, vcat(path, (i + 1, j))))
            else
                push!(tovisit, (d + 1001, i - 1, j, up, vcat(path, (i - 1, j))))
                push!(tovisit, (d + 1, i, j + 1, right, vcat(path, (i, j + 1))))
                push!(tovisit, (d + 1001, i + 1, j, down, vcat(path, (i + 1, j))))
            end
        end
    end
    return length(totaltiles)
    error("No path found        ")
end

function main()

    p1 = @time part1()
    p2 = @time part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

