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
    i, j = find_xy(input)

    dir::Direction = up
    while true
        newi, newj = add_dir(i, j, dir)
        try
            if input[newi][newj] == '#'
                dir = next_dir(dir)
            end
            newi, newj = add_dir(i, j, dir)

            if input[newi][newj][1] != '#'

                newi, newj = add_dir(i, j, dir)
                input[newi][newj] = '^'
                input[i][j] = 'X'
                i, j = newi, newj
            end

        catch
            break
        end
    end

    return sum(count.(==('X'), input)) + 1
end

function is_loop(input::Vector, dir::Direction)::Bool
    input = deepcopy(input)
    i, j = find_xy_3d(input)
    while true
        try
            newi, newj = add_dir(i, j, dir)

            olddir = dir
            if input[newi][newj][1] == '#'
                dir = next_dir(dir)
            end

            # println("[LOOP] New loc: $newi, $newj, $dir. ($(input[newi][newj][2]))")

            if input[newi][newj][1] != '#'
                if in(dir, input[newi][newj][2])
                    return true
                end

                newi, newj = add_dir(i, j, dir)
                input[i][j][1] = 'X'
                push!(input[i][j][2], olddir)
                input[newi][newj][1] = '^'
                i, j = newi, newj
            end
        catch
            return false
        end
    end
end

function part2()
    input = map.(x -> [x, Set()], collect.(get_input()))

    dir::Direction = up
    inii, inij = find_xy_3d(input)
    i, j = inii, inij

    obstacles = Set()
    c = 0
    while true
        try
            newi, newj = add_dir(i, j, dir)

            println(c, ": ", newi, " ", newj)

            olddir = dir
            push!(input[i][j][2], olddir)

            if input[newi][newj][1] == '#'
                dir = next_dir(dir)
            end
            newi, newj = add_dir(i, j, dir)

            if input[newi][newj][1] != '#'
                input[newi][newj][1] = '#'

                # println("New dir: $newi, $newj, $dir")

                if (newi != inii || newj != inij) && ((newi, newj) in obstacles || is_loop(input, olddir))
                    # println("Found correct obstacle at $newi, $newj")
                    push!(obstacles, (newi, newj))
                end

                input[i][j][1] = c
                input[newi][newj][1] = '^'
                i, j = newi, newj
                c += 1
            end

        catch
            break
        end
    end

    # println.(input)
    println(obstacles)
    return length(obstacles)
end

function main()

    p1 = part1()
    println("Part 1: $p1")

    p2 = part2()
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

