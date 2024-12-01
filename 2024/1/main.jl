using StatsBase

input = readlines("1/input.in", keep=true)

first = []
second = []

for line in input
    nums = split(line, "   ")

    append!(first, parse(Int, nums[1]))
    append!(second, parse(Int, nums[2]))
end

sort!(first)
sort!(second)

num = reduce(((s, a) -> s + (max(a[1], a[2]) - min(a[1], a[2]))), zip(first, second), init=0)

println("Part one solution: $num")

occs = countmap(second)
num = reduce((s, a) -> s + a * (haskey(occs, a) ? occs[a] : 0), first, init=0)

println("Part two solution: $num")
