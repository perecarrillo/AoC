
function part1(nums)
    up = foldl(((safe, prev), x) -> (safe && x > prev && x <= prev + 3, x), nums, init=(true, nums[1] - 1))[1]
    down = foldl(((safe, prev), x) -> (safe && x < prev && x >= prev - 3, x), nums, init=(true, nums[1] + 1))[1]

    return up || down
end

function part2(nums)
    safe = part1(nums)

    for i = 1:length(nums)
        if safe
            break
        end
        safe = part1(nums[begin:end.!=i])
    end

    return safe
end

input = readlines("2/input.in", keep=true)

suma1 = 0
suma2 = 0

for line in input
    nums = map(x -> parse(Int, x), split(line, " "))

    global suma1 += Int(part1(nums))
    global suma2 += Int(part2(nums))

end

println("Part 1: $suma1")
println("Part 2: $suma2")

