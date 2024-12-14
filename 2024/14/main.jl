include("../utils.jl")

function getinput()
    return readlines("14/input.in", keep=false)
end

function part1()
    input = getinput()

    width = 101
    height = 103
    # width = 11
    # height = 7

    midx = width ÷ 2
    midy = height ÷ 2

    time = 100

    finalpos = Dict()
    
    for line in input
        (px, py), (vx, vy) = map.(y->parse(Int, y), split.(map(x->strip(x, ['p', '=', 'v']), split(line, " ")), ","))

        finalx = (px + vx * time)
        finaly = (py + vy * time)
        while finalx < 0
            finalx += width
        end
        while finaly < 0
            finaly += height
        end

        finalx = finalx % width
        finaly = finaly % height

        if (finalx != midx) && (finaly != midy)
            if haskey(finalpos, (finalx, finaly))
                finalpos[(finalx, finaly)] += 1
            else
                finalpos[(finalx, finaly)] = 1
            end
        end
    end

    q1 = sum(x->x[2], filter(y->y[1][1] < midx && y[1][2] < midy, finalpos))
    q2 = sum(x->x[2], filter(y->y[1][1] > midx && y[1][2] < midy, finalpos))
    q3 = sum(x->x[2], filter(y->y[1][1] < midx && y[1][2] > midy, finalpos))
    q4 = sum(x->x[2], filter(y->y[1][1] > midx && y[1][2] > midy, finalpos))

    return q1*q2*q3*q4
end

function part2()
    input = getinput()

    width = 101
    height = 103

    midx = width ÷ 2
    midy = height ÷ 2

    ini::Any = nothing

    time = 0
    while true
        print(stderr, "Iteration: $time     \r")

        mapa::Matrix{Any} = fill(0, (width, height))
        
        for line in input
            (px, py), (vx, vy) = map.(y->parse(Int, y), split.(map(x->strip(x, ['p', '=', 'v']), split(line, " ")), ","))
            
            finalx = (px + vx * time)
            finaly = (py + vy * time)
            while finalx < 0
                finalx += width
            end
            while finaly < 0
                finaly += height
            end

            finalx = finalx % width
            finaly = finaly % height

            mapa[finalx+1, finaly+1] += 1
        end

        
        if sum(count.(==(1), eachrow(mapa)) .> 30) >= 2  && sum(count.(==(1), eachcol(mapa)) .> 30) >= 2
            # replace!(mapa, 0=>'.')
            # println("\n\nTIME: $time")
            # display(mapa)

            return time
        end
        
        if time == 0
            ini = deepcopy(mapa)
        elseif mapa == ini
            println(stderr, "\n\nFound loop at!: $time")
            break
        end
        time += 1
    end
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

