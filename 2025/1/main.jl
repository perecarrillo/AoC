include("../utils.jl")

function getinput()
    return readlines("1/input.in", keep=false)
end

function part1()
    input = getinput()

    dial = 50

    zeros = 0
    
    for line in input
        rot = line[1]
        num = parse(Int, line[2:end])

        if rot == 'L'
            dial = (dial + num) % 100
        elseif rot == 'R'
            dial = (dial - num + 1000000000000000000000000000) % 100
        end

        if dial == 0
            zeros += 1
        end
    end

    return zeros
end

function part2()
    input = getinput()

    dial = 50

    zeros = 0
    
    for line in input
        rot = line[1]
        num = parse(Int, line[2:end])
        
        if rot == 'L'
            dial = (dial + num)
                        
            while dial >= 100
                zeros += 1
                dial -= 100
            end
            
        elseif rot == 'R'
            inidial = dial
            dial = (dial - num)
            
            while dial < 0
                if inidial != 0
                    zeros += 1
                end
                inidial = dial
                dial += 100
            end
            
            if dial == 0
                zeros += 1
            end
        end
    end

    return zeros
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

