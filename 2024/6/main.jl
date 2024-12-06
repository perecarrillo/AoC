include("../utils.jl")

function get_input()
    return readlines("6/input.in", keep=false)
end

@enum Direction begin
    none = 0
    up = 1
    right = 2
    down = 3
    left = 4
end

function find_xy(mapa)
    i = j = 0

    for (x, line) in enumerate(mapa)
        if '^' in line
            i = x
            j = findall(==('^'), line)[1]
        end
    end

    return i, j
end

function find_xy_3d(mapa)
    i = j = 0

    for (x, line) in enumerate(mapa)
        if length(local arr = findall(x -> x[1] == '^', line)) > 0
            i = x
            j = arr[1]
        end
    end
    return i, j
end

function add_dir(i, j, dir)

    if dir == up
        return i - 1, j
    elseif dir == down
        return i + 1, j
    elseif dir == left
        return i, j - 1
    else
        return i, j + 1
    end

end

function next_dir(dir)
    if dir == up
        return right
    elseif dir == down
        return left
    elseif dir == left
        return up
    else
        return down
    end

end

function part1()
    input = collect.(get_input())

    dir::Direction = up
    inii, inij = find_xy(input)
    i, j = inii, inij

    visited = Set()

    while true
        try
            push!(visited, (i, j))
            
            newi, newj = add_dir(i, j, dir)
            while input[newi][newj][1] == '#'
                dir = next_dir(dir)
                newi, newj = add_dir(i, j, dir)
            end
            i, j = newi, newj
        catch
            break
        end
    end

    return length(visited)
end

function is_loop(input::Vector, i::Int, j::Int, dir::Direction)::Bool
    visited = Set()
    while true
        try
            # println("[LOOP] ", i, " ", j, " ($dir)")

            if (i, j, dir) in visited
                return true
            end
            
            
            push!(visited, (i, j, dir))
            
            newi, newj = add_dir(i, j, dir)
            while input[newi][newj] == '#'
                dir = next_dir(dir)
                newi, newj = add_dir(i, j, dir)
            end
 
            i, j = newi, newj
        catch
            return false
        end
    end
end

function part2()
    input = collect.(get_input())

    dir::Direction = up
    inii, inij = find_xy(input)
    i, j = inii, inij

    obstacles = Set()
    c = 0

    visited = Set()

    while true
        try
            # println(c, ": ", i, " ", j, " ($dir)")
            push!(visited, (i, j))
            
            newi, newj = add_dir(i, j, dir)
            while input[newi][newj] == '#'
                dir = next_dir(dir)
                newi, newj = add_dir(i, j, dir)
            end

            # println("Next position: $newi, $newj")

            old = input[newi][newj]
            input[newi][newj] = '#'
            if (newi != inii || newj != inij) && ((newi, newj) in obstacles || is_loop(input, inii, inij, up))
                # println("Found obstacle in $newi, $newj")
                push!(obstacles, (newi, newj))
            end
            input[newi][newj] = old

            i, j = newi, newj
            c += 1
        catch
            break
        end
    end

    return length(obstacles)
end

function main()

    p1 = @time part1()
    println("Part 1: $p1")
    
    p2 = @time part2()
    println("Part 2: $p2")

end

main()

