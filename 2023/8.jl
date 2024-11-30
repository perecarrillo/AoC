using Graphs
using MetaGraphsNext

directions = readline()
readline() # white line

lines = readlines()

graph = MetaGraph(
    DiGraph();
    Label=String,
    VertexData=String,
    EdgeData=String,
    graph_data="Map",
)

graph["L"] = "L"
graph["R"] = "R"

v = []

for i = firstindex(lines):lastindex(lines)
    from = lines[i][1:3]
    left = lines[i][8:10]
    right = lines[i][13:15]
    graph[from] = from
    graph[left] = left
    graph[right] = right
    graph[from, "L"] = left
    graph[from, "R"] = right
    # println("Name: $from, Left: $left, Right: $right")
    global v = push!(v, from)
end


# idx = 1
# steps = 0

# Part one
# actualNode = "AAA"

# while actualNode != "ZZZ"
#     # println("While")
#     # println(directions[idx])
#     global actualNode = graph[actualNode, string(directions[idx])]
#     # println(actualNode)
#     global idx += 1
#     if idx > lastindex(directions)
#         global idx = 1
#     end
#     global steps += 1
# end

actualNodes = filter(x -> x[3] == 'A', v)

iterations = [] # fill([], size(actualNodes))

for it = firstindex(actualNodes):lastindex(actualNodes)
    node = actualNodes[it]
    println(node)
    idx = 1
    steps = 0
    localIterations = []
    for i=1:1
        while node[3] != 'Z'
            # println(directions)
            node = graph[node, string(directions[idx])]
            # println(node)
            idx += 1
            if idx > lastindex(directions)
                idx = 1
            end
            steps += 1
        end
        # print(steps)
        global iterations = push!(iterations, steps)
        localIterations = push!(localIterations, steps)
        node = graph[node, string(directions[idx])]
        idx += 1
        if idx > lastindex(directions)
            idx = 1
        end
        steps += 1
    end
    # global iterations = push!(iterations, localIterations)
end

println("Iterations: ")
println(iterations)

println(reduce(lcm, iterations))
