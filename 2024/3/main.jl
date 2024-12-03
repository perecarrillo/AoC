function sum_mult_matches(str)
    matches = [match.match for match in eachmatch(r"mul\(\d{1,3},\d{1,3}\)", str)]

    # "pretty" one liner
    return sum(x -> *(parse.(Int, split(x[5:end-1], ","))...), matches)

    # suma = 0

    # for match in matches
    #     num1, num2 = parse.(Int, split(match[5:end-1], ","))

    #     suma += num1 * num2
    # end

    # return suma
end

input = readlines("3/input.in", keep=false)

input = join(input)

println("Part 1: $(sum_mult_matches(input))")

match2 = [match.match for match in eachmatch(r"(^|do|don't)((.*?))(do|don't|$)", input, overlap=true)]

suma = sum(sum_mult_matches, filter(x -> x[begin:7] != "don't()", match2))

println("Part 2: $suma")