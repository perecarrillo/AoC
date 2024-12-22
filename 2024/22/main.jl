include("../utils.jl")

using ProgressBars

function getinput()
    return readlines("22/input.in", keep=false)
end

function getnthrandomnumber(seed::Int, n::Int)
    x = seed
    for _ = 1:n
        x = (x ⊻ (x * 64)) % 16777216
        x = (x ⊻ (x ÷ 32)) % 16777216
        x = (x ⊻ (x * 2048)) % 16777216
    end

    return x
end

function getnthrandomnumbersmod10(seed::Int, n::Int)
    total = [seed]
    for i = 1:n
        x = total[end]
        x = (x ⊻ (x * 64)) % 16777216
        x = (x ⊻ (x ÷ 32)) % 16777216
        x = (x ⊻ (x * 2048)) % 16777216
        push!(total, x)
    end
    return map(x -> x % 10, total)
end

function part1()
    input = parse.(Int, getinput())

    total::BigInt = 0
    for line in input
        total += getnthrandomnumber(line, 2000)
    end

    return total
end

function part2()
    input = parse.(Int, getinput())

    allsequences = Set{Vector}()
    winnings = []

    for line in ProgressBar(input)
        numbers = getnthrandomnumbersmod10(line, 2000)
        changes = [numbers[i] - numbers[i-1] for i in 2:length(numbers)]
        sequences = [changes[i:i+3] for i in 1:length(changes)-3]
        maxbananas = Dict()
        for (seq, ban) in zip(sequences, numbers[5:end])
            if !haskey(maxbananas, seq) # || maxbananas[seq] < ban
                maxbananas[seq] = ban
            end
        end
        push!(winnings, maxbananas)
        push!(allsequences, sequences...)
    end

    bestbananas = 0
    for sequence in ProgressBar(allsequences)
        totalbananas = 0
        for dict in winnings
            totalbananas += get(dict, sequence, 0)
        end
        if totalbananas > bestbananas
            bestbananas = totalbananas
        end
    end

    return bestbananas
end

function main()

    p1 = @time part1()
    p2 = @time part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

