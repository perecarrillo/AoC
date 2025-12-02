include("../utils.jl")

function getinput()
    return readlines("2/input.in", keep=false)
end

function part1()
    input = getinput()[1]
    
    ranges = split(input, ",")

    sum = 0

    for r in ranges
        first, last = split(r, "-")

        for num in range(parse(Int, first), parse(Int, last))
            asstring = string(num)

            f = asstring[1:length(asstring)÷2]
            l = asstring[length(asstring)÷2+1:end]

            if f == l
                sum += num
            end
        end
    end

    return sum
end

function part2()
    input = getinput()[1]
    
    ranges = split(input, ",")

    sum = 0

    for r in ranges
        first, last = split(r, "-")

        for num in range(parse(Int, first), parse(Int, last))
            asstring = string(num)

            found = false

            for len in range(1, length(asstring)÷2)
                if length(asstring) % len != 0
                    continue
                end
                repeats = true
                for cut in range(len*2, length(asstring), step=len)
                    if asstring[1:len] != asstring[cut-len+1:cut]
                        repeats = false
                        break
                    end
                end
                if repeats
                    sum += num
                    found = true
                    break
                end
            end
        end
    end

    return sum
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

