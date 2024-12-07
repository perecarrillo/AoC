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
end

if !isfile(joinpath(path, "test.in"))
    touch(joinpath(path, "test.in"))
end
if !isfile(joinpath(path, "main.jl"))
    touch(joinpath(path, "main.jl"))

    open(joinpath(path, "main.jl"), "w") do file
        write(file,
            """
            include("../utils.jl")

            function get_input()
                return readlines("$day/input.in", keep=false)
            end

            function part1()
                input = get_input()
                
                for line in input
                    println(line)
                end

                return 0
            end

            function part2()
                input = get_input()
                
                for line in input
                    println(line)
                end

                return 0
            end

            function main()

                p1 = @time part1()
                p2 = @time part2()
                
                println("Part 1: \$p1")
                println("Part 2: \$p2")

            end

            main()

            """
        )
    end
end

if !isfile(joinpath(path, "input.in")) || length(readlines("$day/input.in")) == 0
    touch(joinpath(path, "input.in"))

    if !haskey(ENV, "SESSION") || ENV["SESSION"] == ""
        error("Session cookie not found. Make sure it is set in the .env file.")
    end
    cookies = Dict("session" => ENV["SESSION"])

    resp = HTTP.get("https://adventofcode.com/$YEAR/day/$day/input", cookies=cookies, status_exception=false)

    if HTTP.iserror(resp)
        error("Unable to get input for day $day.")
    else
        open(joinpath(path, "input.in"), "w") do file
            write(file, resp.body)
        end
    end

end

