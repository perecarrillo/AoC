include("../utils.jl")

function getinput()
    return readlines("11/input.in", keep=false)
end

cache = Dict{Tuple{String, Dict{String, Bool}}, Int}()

function findout(currentdevice::String, outputs::Dict, required::Set{String})::Int
    function innerfindout(device::String, path::Set{String})::Int
        key = (device, Dict(d => d in path for d in required))

        if key in keys(cache)
            return cache[key]
        end

        if device == "out"
            return issubset(required, path) ? 1 : 0
        end

        result = sum(d->innerfindout(d, union(path, [d])), outputs[device])
        cache[key] = result
        return result
    end

    return innerfindout(currentdevice, Set{String}())
end

function part1()
    input = Dict(k => Set(String.(split(v, " "))) for (k, v) in split.(getinput(), ": "))    

    return findout("you", input, Set{String}())
end

function part2()
    input = Dict(k => Set(String.(split(v, " "))) for (k, v) in split.(getinput(), ": "))    

    return findout("svr", input, Set(["dac", "fft"]))
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()
