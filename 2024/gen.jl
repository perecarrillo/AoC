using Dates, HTTP, JSON3, DotEnv

#
# To get the session cookie, open adventofcode.com -> f12 -> Application -> cookies
#

DotEnv.load!()

const YEAR::Int = 2024

if length(ARGS) == 1
    day::Int = parse(Int, ARGS[1])
else
    day::Int = parse(Int, (rsplit(string(today()), "-", limit=2)[end]))
end

path = joinpath(pwd(), string(day))

if !isdir(path)
    mkpath(path)
    touch(joinpath(path, "input.in"))
    touch(joinpath(path, "test.in"))
    touch(joinpath(path, "main.jl"))

    open(joinpath(path, "main.jl"), "w") do file
        write(file,
            """

            input = readlines("$day/input.in", keep=true)

            for line in input
                print(line)
            end

            """
        )
    end

    cookies = Dict("session" => ENV["SESSION"])

    resp = HTTP.get("https://adventofcode.com/$YEAR/day/$day/input", cookies=cookies)

    open(joinpath(path, "input.in"), "w") do file
        write(file, resp.body)
    end

end

