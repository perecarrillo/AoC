include("../utils.jl")

function getinput()
    return readlines("15/input.in", keep=false)
end

function nextpos(m, (i, j))
    if m == '^'
        return i-1, j
    elseif m == 'v'
        return i+1, j
    elseif m == '<'
        return i, j-1
    elseif m == '>'
        return i, j+1
    else
        error("Invalid direction $m")
    end
end

function move(warehouse, m, inii, inij)
    @assert(warehouse[inii][inij] == '@')
    i, j = inii, inij

    while true
        i, j = nextpos(m, (i, j))

        if warehouse[i][j] == '.'
            ri, rj = nextpos(m, (inii, inij))
            # println("<moving robot from ($inii, $inij) to ($ri, $rj). Explored ($i, $j)")
            warehouse[inii][inij] = '.'
            warehouse[ri][rj] = '@'
            if i != ri || j != rj
                warehouse[i][j] = 'O'
            end
            return ri, rj
        elseif warehouse[i][j] == '#'
            return inii, inij
        end
        
    end
end

function canbigmove(warehouse, m, inii, inij)
    i, j = nextpos(m, (inii, inij))
    # println("Calling canbigmove with $m, $inii, $inij. This position is $(warehouse[inii][inij]). Next position is $(warehouse[i][j])")
    if warehouse[i][j] == '#'
        return false
    elseif warehouse[i][j] == '.'
        return true
    end

    if m in ['^', 'v']
        if warehouse[i][j] == '['
            return canbigmove(warehouse, m, i, j) && canbigmove(warehouse, m, i, j+1)
        elseif warehouse[i][j] == ']'
            return canbigmove(warehouse, m, i, j) && canbigmove(warehouse, m, i, j-1)
        end
    else
        return canbigmove(warehouse, m, i, j)
    end
    error("Invalid location found at ($i, $j: $(warehouse[i][j]))")
end

"""
This function assumes that the robot and all the following obstacles can be moved in the direction m.
"""
function makebigmove(warehouse, m, inii, inij)
    if warehouse[inii][inij] == '#'
        error("makebigmove could not move to ($inii, $inij)!!!!!")
    elseif warehouse[inii][inij] == '.'
        return
    end
    
    i, j = nextpos(m, (inii, inij))

    if m in ['^', 'v']
        if warehouse[i][j] == '['
            makebigmove(warehouse, m, i, j)
            makebigmove(warehouse, m, i, j+1)
            warehouse[i][j] = warehouse[inii][inij]
            warehouse[inii][inij] = '.'

            return
        elseif warehouse[i][j] == ']'
            makebigmove(warehouse, m, i, j)
            makebigmove(warehouse, m, i, j-1)
            warehouse[i][j] = warehouse[inii][inij]
            warehouse[inii][inij] = '.'
            
            return
        elseif warehouse[i][j] == '.'
            warehouse[i][j] = warehouse[inii][inij]
            warehouse[inii][inij] = '.'
            return
        end
    else
        makebigmove(warehouse, m, i, j)
        warehouse[i][j] = warehouse[inii][inij]
        warehouse[inii][inij] = '.'
        return
    end
end

function bigmove(warehouse, m, inii, inij)
    @assert(warehouse[inii][inij] == '@')
    if canbigmove(warehouse, m, inii, inij)
        makebigmove(warehouse, m, inii, inij)
        return nextpos(m, (inii, inij))
    end
    return inii, inij
end

function getsumgps(warehouse, c = 'O')
    total = 0

    for i in 1:length(warehouse)
        for j in 1:length(warehouse[i])
            if warehouse[i][j] == c
                total += 100*(i-1) + (j-1)
            end
        end
    end
    return total
end

function part1()
    input = getinput()

    warehouse, moves = splitby(==(""), input)

    warehouse = collect.(warehouse)

    moves = join(moves)

    i, j = findindices2d(warehouse, '@')[1]
    
    for m in moves
        i, j = move(warehouse, m, i, j)
        # println.(warehouse)
    end


    return getsumgps(warehouse)
end

function part2()
    input = getinput()

    warehouse, moves = splitby(==(""), input)

    warehouse = collect.(warehouse)

    moves = join(moves)

    bigwarehouse = []

    for line in warehouse
        bigline = []
        for item in line

            if item == '@'
                bigitem = ['@', '.']
            elseif item == 'O'
                bigitem = ['[', ']']
            else
                bigitem = [item, item]
            end
            append!(bigline, bigitem)
        end
        push!(bigwarehouse, bigline)
    end
    
    i, j = findindices2d(bigwarehouse, '@')[1]
    # println.(bigwarehouse)
    
    for m in moves
        i, j = bigmove(bigwarehouse, m, i, j)
        # println.(bigwarehouse)
    end

    return getsumgps(bigwarehouse, '[')
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

