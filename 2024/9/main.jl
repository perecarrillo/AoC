include("../utils.jl")

function getinput()
    return readlines("9/input.in", keep=false)
end

function part1()
    input::Vector{Any} = parse.(Int, collect(getinput()[1]))

    idx = 0
    for i in 1:length(input)
        if i % 2 == 1
            input[i] = (input[i], idx)
            idx += 1
        else
            input[i] = (input[i], -1)
        end
    end

    it = 0
    countback = 0

    ini = 1
    back = length(input)

    total = 0

    while ini <= back
        # println("Testing (it: $it, ini: $ini, back: $back, countback: $countback)")
        if input[ini][2] != -1
            for i in 1:input[ini][1]
                # if ini >= back && i >= countback - 1
                #     break
                # end
                total += (it * input[ini][2])
                # println("Front: 1 of $(input[ini][2]), adding $((it * input[ini][2])). (it: $it, ini: $ini, back: $back, countback: $countback)")
                it += 1
            end
            ini += 1
        else
            for i in 1:input[ini][1]
                if ini >= back && i >= countback - 1
                    break
                end
                total += (it * input[back][2])
                # println("Back: 1 of $(input[back][2]), adding $((it * input[back][2])). (it: $it, ini: $ini, back: $back, countback: $countback)")

                it += 1
                countback += 1
                if countback >= input[back][1]
                    back -= 2
                    countback = 0
                end
            end
            ini += 1
        end
    end

    return total
end

function findbestposition(disk, idx)
    for i in 1:idx
        if disk[i][2] == -1
            if disk[i][1] >= disk[idx][1]
                return i
            end
        end
    end
    return idx
end

function part2()
    input::Vector{Any} = parse.(Int, collect(getinput()[1]))

    idx = 0
    for i in 1:length(input)
        if i % 2 == 1
            input[i] = (input[i], idx)
            idx += 1
        else
            input[i] = (input[i], -1)
        end
    end

    i = length(input)
    while i > 0
        if input[i][2] != -1
            newidx = findbestposition(input, i)

            if i != newidx
                freespace = input[newidx][1] - input[i][1]

                input[newidx] = input[i]
                input[i] = (input[i][1], -1)
                if freespace > 0
                    insert!(input, newidx + 1, (freespace, -1))
                end
            end
        end
        i -= 1
    end

    it = 0
    ini = 1
    total = 0
    while ini <= length(input)
        for i in 1:input[ini][1]
            if input[ini][2] != -1
                total += (it * input[ini][2])
            end
            it += 1
        end
        ini += 1
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

