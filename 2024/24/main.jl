include("../utils.jl")

using Combinatorics, Distributed

function getinput()
    return readlines("24/input.in", keep=false)
end

function getresult(out, known, operations, usemem=true)
    if (usemem || out[1] == 'x' || out[1] == 'y') && haskey(known, out)
        return known[out]
    end

    # println("Computing $(operations[out]) = $out")

    in1, op, in2 = operations[out]

    involved = Set([(join(operations[out], " "), out)])

    in1, involved1 = getresult(in1, known, operations, usemem)
    in2, involved2 = getresult(in2, known, operations, usemem)

    union!(involved, involved1, involved2)

    if op == "AND"
        value = in1 && in2
    elseif op == "OR"
        value = in1 || in2
    elseif op == "XOR"
        value = in1 ⊻ in2
    else
        error("Invalid operation $op")
    end


    known[out] = (value, involved)

    return value, involved
end

function part1()
    input = getinput()

    init, gates = splitby(==(""), input)

    known = Dict()
    for i in init
        g, v = split(i, ':')

        v = parse(Bool, replace(v, " " => ""))

        known[g] = (v, Set())
    end

    maxz = 0
    operations = Dict()
    for c in gates
        out = split(c, " -> ")[end]
        in1, op, in2 = split(split(c, " -> ")[begin], " ")

        operations[out] = (in1, op, in2)

        if out[1] == 'z'
            maxz = max(maxz, parse(Int, out[2:end]))
        end
    end

    zval = ""
    for i in 0:maxz
        id = i <= 9 ? "z0$i" : "z$i"

        res, _ = getresult(id, known, operations)

        zval = (res ? "1" : "0") * zval
    end

    return parse(Int, zval, base=2)
end

function printoperation(out, known, operations, depth=0; maxdepth=3)
    if haskey(known, out) || depth >= maxdepth
        return out
        # return known[out]
    end

    i1, op, i2 = operations[out]

    in1 = printoperation(i1, known, operations, depth + 1; maxdepth=maxdepth)
    in2 = printoperation(i2, known, operations, depth + 1; maxdepth=maxdepth)

    return "($in1:$i1 $op $i2:$in2)"

    if op == "AND"
        value = in1 && in2
    elseif op == "OR"
        value = in1 || in2
    elseif op == "XOR"
        value = in1 ⊻ in2
    else
        error("Invalid operation $op")
    end
    # known[out] = value
    return value
end

function getresult2(out, known, operations)
    if haskey(known, out)
        return known[out]
    end

    i1, op, i2 = operations[out]

    in1 = getresult2(i1, known, operations)
    in2 = getresult2(i2, known, operations)

    # return "($in1:$i1 $op $i2:$in2)"

    if op == "AND"
        value = in1 && in2
    elseif op == "OR"
        value = in1 || in2
    elseif op == "XOR"
        value = in1 ⊻ in2
    else
        error("Invalid operation $op")
    end
    known[out] = value
    return value
end

function part2()
    input = getinput()

    init, gates = splitby(==(""), input)

    maxx = 0
    maxy = 0
    known = Dict()
    for i in init
        g, v = split(i, ':')

        v = parse(Bool, replace(v, " " => ""))

        known[g] = (v, Set())

        if g[1] == 'x'
            maxx = max(maxx, parse(Int, g[2:end]))
        end
        if g[1] == 'y'
            maxy = max(maxy, parse(Int, g[2:end]))
        end
    end

    maxz = 0
    operations = Dict()
    for c in gates
        out = split(c, " -> ")[end]
        in1, op, in2 = split(split(c, " -> ")[begin], " ")

        operations[out] = (in1, op, in2)

        if out[1] == 'z'
            maxz = max(maxz, parse(Int, out[2:end]))
        end
    end

    operations["z05"], operations["dkr"] = operations["dkr"], operations["z05"]
    operations["z15"], operations["htp"] = operations["htp"], operations["z15"]
    operations["z20"], operations["hhh"] = operations["hhh"], operations["z20"]
    operations["rhv"], operations["ggk"] = operations["ggk"], operations["rhv"]

    for i in 0:maxz
        id = i <= 9 ? "z0$i" : "z$i"

        res = printoperation(id, known, operations; maxdepth=2)[2:end-1]

        println("$id = $res")
    end

    # x
    xval = ""
    xbits = []
    for i in 0:maxx
        id = i <= 9 ? "x0$i" : "x$i"
        res, _ = getresult(id, known, operations)

        xval = (res ? "1" : "0") * xval
        pushfirst!(xbits, res)
    end

    # y
    yval = ""
    ybits = []
    for i in 0:maxy
        id = i <= 9 ? "y0$i" : "y$i"
        res, _ = getresult(id, known, operations)

        yval = (res ? "1" : "0") * yval
        pushfirst!(ybits, res)
    end

    zval = ""
    for i in 0:maxz
        id = i <= 9 ? "z0$i" : "z$i"

        res, _ = getresult(id, known, operations)

        zval = (res ? "1" : "0") * zval
    end

    println("x: $xval")
    println("y: $yval")
    println("z: $zval")

    println("Expected: $(parse(Int, xval, base=2) + parse(Int, yval, base=2))")
    println("Actual: $(parse(Int, zval, base=2))")

    if parse(Int, zval, base=2) != parse(Int, xval, base=2) + parse(Int, yval, base=2)
        return false
    end

    swapers = ["ggk", "rhv", "z05", "dkr", "z15", "htp", "z20", "hhh"]

    sort!(swapers)

    return join(swapers, ",")
end

function iscorrect(maxz, known, operations, xbits, ybits)
    carry = false
    for i in 0:maxz
        id = i <= 9 ? "z0$i" : "z$i"
        actual, _ = getresult(id, known, operations, false)

        x = i >= length(xbits) ? false : xbits[end-i]
        y = i >= length(ybits) ? false : ybits[end-i]

        expected = x ⊻ y ⊻ carry

        if expected != actual
            return false
        end
        carry = x && y || (x ⊻ y) && carry
    end
    return true
end

function main()

    p1 = @time part1()
    p2 = @time part2()

    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()

