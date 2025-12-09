include("../utils.jl")
using Plots

function getinput()
    return readlines("9/input.in", keep=false)
end

function distance(x::Vector{Int}, y::Vector{Int})
    # return sqrt(sum((x.-y).^2))
    return sum(x->x^2, (x.-y))
end

function area(x::Vector{Int}, y::Vector{Int})
    base = max(x[1], y[1]) - min(x[1], y[1]) + 1
    h = max(x[2], y[2]) - min(x[2], y[2]) + 1
    return base * h
end

function part1()
     input = map(x->parse.(Int, split(x, ",")), getinput())

    distances::Vector{Tuple{Int, Int, Int}} = [(distance(input[i], input[j]), i, j) for i in eachindex(input) for j in i+1:length(input)]

    # sort!(distances, by=x->x[1], rev=true)

    max = maximum(distances)

    # println.(collect(enumerate(input)))
    # println(distances)

    println("Corners: $(input[max[2]]), $(input[max[3]])")

    return area(input[max[2]], input[max[3]])
end

struct Tile
    x::Int
    y::Int
end

function distancesq(x::Tile, y::Tile)
    return (x.x-y.x)^2 + (x.y-y.y)^2
end

function area(x::Tile, y::Tile)
    base = max(x.x, y.x) - min(x.x, y.x) + 1
    h = max(x.y, y.y) - min(x.y, y.y) + 1
    return base * h
end

# function isinside((dist, i, j)::Tuple{Number, Int, Int}, tiles:: Vector{Tile})
#     xmin = min(tiles[i].x, tiles[j].x)
#     xmax = max(tiles[i].x, tiles[j].x)

#     ymin = min(tiles[i].y, tiles[j].y)
#     ymax = max(tiles[i].y, tiles[j].y)

#     ntiles = length(tiles)

#     inxmin = []
#     inxmax = []
#     inymin = []
#     inymax = []

#     for (i, tile) in enumerate(tiles)
#         if tile.x > xmin && tile.x < xmax && tile.y > ymin && tile.y < ymax
#             return false
#         elseif tile.x == xmin && tile.y > ymin && tile.y < ymax
#             push!(inxmin, i)
#         elseif tile.x == xmax && tile.y > ymin && tile.y < ymax
#             push!(inxmax, i)
#         elseif tile.y == ymin && tile.x > xmin && tile.x < xmax
#             push!(inymin, i)
#         elseif tile.y == ymax && tile.x > xmin && tile.x < xmax
#             push!(inymax, i)
#         end
#     end

#     println("Pair [$i, $j] valid, checking borders")
#     println("---> Ntiles: $ntiles")
#     println("---> inxmax: $inxmax")
#     println("---> inxmin: $inxmin")
#     println("---> inymin: $inymin")
#     println("---> inymax: $inymax")

#     if ntiles in inxmin
#         push!(inxmin, 0)
#     end
#     if ntiles in inxmax
#         push!(inxmax, 0)
#     end
#     if ntiles in inymin
#         push!(inymin, 0)
#     end
#     if ntiles in inymax
#         push!(inymax, 0)
#     end

#     for x in inxmin
#         if x+1 in inxmax
#             return false
#         end
#     end
#     for x in inxmax
#         if x+1 in inxmin
#             return false
#         end
#     end
#     for y in inymin
#         if y+1 in inymax
#             return false
#         end
#     end
#     for y in inymax
#         if y+1 in inymin
#             return false
#         end
#     end

#     println("Passed inborders check")

#     return true
# end

# Thanks for nothing GEOC
function orTest(p::Tile, q::Tile, r::Tile) :: Number
    return (q.x - p.x) * (r.y - p.y) - (q.y - p.y) * (r.x - p.x)
end

function isSamePoint(p1::Tile, p2::Tile)
	return p1.x == p2.x && p1.y == p2.y
end

function differentSign(x, y)
	return x * y < 0
end

function determinant(x, a, b, c)
	d00 = b.x - a.x
	d01 = b.y - a.y
	d02 = (b.x - a.x) * (b.x + a.x) + (b.y - a.y) * (b.y + a.y)
	d10 = c.x - a.x
	d11 = c.y - a.y
	d12 = (c.x - a.x) * (c.x + a.x) + (c.y - a.y) * (c.y + a.y)
	d20 = x.x - a.x
	d21 = x.y - a.y
	d22 = (x.x - a.x) * (x.x + a.x) + (x.y - a.y) * (x.y + a.y)
	# 3x3 determinant formula
	return d00 * d11 * d22 + d10 * d21 * d02 + d01 * d12 * d20 - d02 * d11 * d20 - d10 * d01 * d22 - d00 * d21 * d12
end

function intersects((t1, t2), (s1, s2))
    if (isSamePoint(t1, s1) && isSamePoint(t2, s2) || isSamePoint(t1, s2) && isSamePoint(t2, s1))
		# Same segment
        return false
    elseif (orTest(t1, t2, s1) == 0 && orTest(t1, t2, s2) == 0)
        # The two segments are in the same line
        s1min = min(t1.x, t2.x)
		s1max = max(t1.x, t2.x)
		s2min = min(s1.x, s2.x)
		s2max = max(s1.x, s2.x)
		if (s1min == s1max) 
			# If vertical lines, change plane
			s1min = min(t1.y, t2.y)
			s1max = max(t1.y, t2.y)
			s2min = min(s1.y, s2.y)
			s2max = max(s1.y, s2.y)
        end
		if (!(s1max >= s2min && s1min <= s2max || s2max >= s1min && s2min <= s1max)) 
			# No collision
            return false
		elseif (s1min >= s2min && s1max <= s2max || s2min >= s1min && s2max <= s1max)
			# one inside the other
			return false
		else 
			# collision
			return false
        end
    elseif (orTest(t1, t2, s1) == 0 || orTest(t1, t2, s2) == 0 || orTest(s1, s2, t1) == 0 || orTest(s1, s2, t2) == 0)
		# End - Mid || End - End
		# Intersect at an endpoint
        return false
	elseif (differentSign(orTest(t1, t2, s1), orTest(t1, t2, s2)) && differentSign(orTest(s1, s2, t1), orTest(s1, s2, t2)))
		# Intersection with no comon endpoints
        return true
	else
        # No collision
        return false
    end
end

function pointinrectangle(tile, (t, s))
    xmin = min(t.x, s.x)
    xmax = max(t.x, s.x)

    ymin = min(t.y, s.y)
    ymax = max(t.y, s.y)

    return tile.x > xmin && tile.x < xmax && tile.y > ymin && tile.y < ymax
end

function isvalid((area, i, j), tiles)

    ntiles = length(tiles)

    # First, check that there are no vertices inside
    for (idx, tile) in enumerate(tiles)
        if pointinrectangle(tile, (tiles[i], tiles[j]))
            # println("[$i, $j] Found point inside ($idx)")
            return false
        end
    end

    # Then, check if it passes through the "middle"
    # To find these numbers, search input for big jumps
    magicn1 = 48734
    magicn2 = 50058
    
    ymin = min(tiles[i].y, tiles[j].y)
    ymax = max(tiles[i].y, tiles[j].y)

    if ymin <= magicn1 && ymax >= magicn2
        return false
    end

    # # Then, check if any edge intersects with it
    # s1 = (Tile(tiles[i].x, tiles[i].y), Tile(tiles[i].x, tiles[j].y))
    # s2 = (Tile(tiles[i].x, tiles[i].y), Tile(tiles[j].x, tiles[i].y))
    # s3 = (Tile(tiles[j].x, tiles[j].y), Tile(tiles[i].x, tiles[j].y))
    # s4 = (Tile(tiles[j].x, tiles[j].y), Tile(tiles[j].x, tiles[i].y))
    # for idx in 1:length(tiles)
    #     next = idx + 1
    #     if next == ntiles + 1
    #         next = 1
    #     end
    #     candidate = (tiles[idx], tiles[next])
    #     if intersects(s1, candidate) || intersects(s2, candidate) || intersects(s3, candidate) || intersects(s4, candidate) || intersects((tiles[i], tiles[j]), candidate)
    #         println("[$i, $j] Found intersection. Collides with [$idx, $next]")
    #         return false
    #     end
    # end

    # Finally, check that the generated rectangle is actually inside the polygon
    # TODO

    return true
end

function part2()
    input = map(x->Tile.(parse.(Int, split(x, ","))...), getinput())

    areas::Vector{Tuple{Number, Int, Int}} = [(area(input[i], input[j]), i, j) for i in eachindex(input) for j in i+1:length(input)] |> filter(x->isvalid(x, input))

    max = maximum(areas)

    ### Testing only
    # m = Array{String}(undef, maximum(x->x.x, input), maximum(x->x.y, input))
    # fill!(m, ".")
    # for (i, t) in enumerate(input)
    #     m[t.x, t.y] = "$i"
    # end
    # display(m)
    ### End testing only
    
    # println("Corners: $(input[max[2]]), $(input[max[3]])")
    # sort!(areas, by=x->x[1], rev=true)
    # println.(collect(enumerate(input)))
    # println(areas)

    # for (d, i, j) in areas
    #     println("Found area: $(area(input[i], input[j])) by [$i, $j]")
    # end

    plot(map(x->x.x, input), map(x->x.y, input); marker=(:circle, 1))

    plot!(Shape([input[max[2]].x, input[max[2]].x, input[max[3]].x, input[max[3]].x], [input[max[2]].y, input[max[3]].y, input[max[3]].y, input[max[2]].y]), opacity=0.5)

    gui()

    sleep(10)

    return max[1]
end

function main()

    p1 = @time part1()
    p2 = @time part2()
    
    println("Part 1: $p1")
    println("Part 2: $p2")

end

main()