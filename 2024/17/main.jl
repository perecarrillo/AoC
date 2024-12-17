include("../utils.jl")

function getinput()
    return readlines("17/input.in", keep=false)
end

function executeinstruction(program, instructionptr, registers)
    op = program[instructionptr]
    val = program[instructionptr+1]

    if val == 4
        combo = registers['A']
    elseif val == 5
        combo = registers['B']
    elseif val == 6
        combo = registers['C']
    else
        combo = val
    end

    # println("Executing $op with val: $val")

    out = nothing
    outptr = instructionptr + 2
    if op == 0
        # adv
        registers['A'] = trunc(registers['A'] / 2^combo)
    elseif op == 1
        #bxl
        registers['B'] = registers['B'] ⊻ val
    elseif op == 2
        #bst
        registers['B'] = mod(combo, 8)
    elseif op == 3
        #jnz
        if registers['A'] != 0
            outptr = val + 1
        end
    elseif op == 4
        # bxc
        registers['B'] = registers['B'] ⊻ registers['C']
    elseif op == 5
        # out
        out = mod(combo, 8)
    elseif op == 6
        # bdv
        registers['B'] = trunc(registers['A'] / 2^combo)
    elseif op == 7
        # cdv
        registers['C'] = trunc(registers['A'] / 2^combo)
    end

    return outptr, out
end

function part1()
    input = getinput()

    registers, program = splitby(==(""), input)
    registers = map(x -> parse(BigInt, split(x, ":")[end]), registers)
    registers = Dict('A' => registers[1], 'B' => registers[2], 'C' => registers[3])

    program = parse.(BigInt, split(program[1][10:end], ","))

    # println(registers)
    # println(program)

    instructionptr = 1

    total = ""

    while instructionptr <= length(program)
        # println("Program at $instructionptr ($(program[instructionptr]), $(program[instructionptr + 1])): Reg: $registers")
        instructionptr, output = executeinstruction(program, instructionptr, registers)


        if !isnothing(output)
            total *= ",$output"
        end
    end

    return total[2:end]
end

function executeprogram(program, registers)
    instructionptr = 1
    total = []
    while instructionptr <= length(program)
        instructionptr, output = executeinstruction(program, instructionptr, registers)

        if !isnothing(output)
            push!(total, output)
        end
    end
    return total
end

function part2()
    input = getinput()

    registers, programstr = splitby(==(""), input)
    registers = map(x -> parse(BigInt, split(x, ":")[end]), registers)
    registers = Dict('A' => registers[1], 'B' => registers[2], 'C' => registers[3])

    programstr = programstr[1][10:end]
    program = parse.(BigInt, split(programstr, ","))

    # 8^15 - 8^16 (salts de 8^15) -> 16 xifres
    # 211106232532992 - 246290604621824 (salts de 8^14) -> acaba amb 0
    # 215504279044096 - 219902325555200 (salts de 8^13) || 233096465088512 - 237494511599616 (salts de 8^13) -> acaba amb 3,0
    # ...
    nextranges = [((8^15):(8^15):(8^16), 0),]


    while true
        range, digitstomatch = popfirst!(nextranges)
        # println("Trying range: $range matching $digitstomatch digits")

        newranges = []

        for (i, val) in enumerate(collect(range)[begin:end-1])
            newregisters = deepcopy(registers)
            newregisters['A'] = val
            total = executeprogram(program, newregisters)
            # println("Tried A: $val. Result: $total (Matching: $(total[end-digitstomatch:end]) and $(program[end-digitstomatch:end]))")

            if total[end-digitstomatch:end] == program[end-digitstomatch:end]
                if total == program
                    # println("Found value!!!")
                    return val
                end
                # println("Found new range: $(val) - $(range[i+1])")
                nextrange = val:(8^(14-digitstomatch)):range[i+1]
                push!(newranges, (nextrange, digitstomatch + 1))
            end
        end

        append!(nextranges, newranges)
    end
end

function main()

    p1 = @time part1()
    p2 = @time part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

