function get_input()
    return readlines("5/input.in", keep=false)
end

function iscorrect(nums, rules)
    correct = true
    inc_num = nothing
    for i in 1:length(nums)
        if !correct
            break
        end
        num = nums[i]
        for prev in nums[1:i-1]
            correct = !haskey(rules, prev) || !in(num, rules[prev])
            if !correct
                inc_num = num
                break
            end
        end
    end
    return (correct, inc_num)
end

function part1()
    input = get_input()

    rules = Dict()
    for line in input
        if isempty(line)
            break
        end
        val, key = map(x -> parse(Int, x), split(line, "|"))

        if haskey(rules, key)
            append!(rules[key], val)
        else
            rules[key] = [val]
        end

    end

    sum = 0

    for line in input
        if occursin("|", line) || isempty(line)
            continue
        end
        nums = map(x -> parse(Int, x), split(line, ","))

        if iscorrect(nums, rules)[1]
            mid = nums[end÷2+1]
            sum += mid
        end
    end

    return sum
end

function part2()
    input = get_input()

    rules = Dict()
    for line in input
        if isempty(line)
            break
        end
        val, key = map(x -> parse(Int, x), split(line, "|"))

        if haskey(rules, key)
            append!(rules[key], val)
        else
            rules[key] = [val]
        end

    end

    sum = 0

    for line in input
        if occursin("|", line) || isempty(line)
            continue
        end
        nums = map(x -> parse(Int, x), split(line, ","))

        correct, _ = iscorrect(nums, rules)

        if !correct
            while !iscorrect(nums, rules)[1]
                println("Checking $nums")
                wrong = iscorrect(nums, rules)[2]
                println("Wrong: $wrong")
                filter!(x -> x ≠ wrong, nums)
                println("Remaining nums: $nums")

                pos = findall(x -> haskey(rules, x) && wrong in rules[x], nums)[begin]
                println("Found position: $(pos)")

                insert!(nums, pos, wrong)
                println("New list: $nums")
            end

            mid = nums[end÷2+1]
            sum += mid
        end
    end

    return sum
end

function main()

    p1 = part1()
    p2 = part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

