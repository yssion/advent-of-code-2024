function draw_chart(chart)
    for i in axes(chart, 1)
        for j in axes(chart, 2)
            print(chart[i, j])
        end
        println()
    end
end    

turn_right(direction) = CartesianIndex(direction[2], -direction[1])
turn_left(direction)  = CartesianIndex(-direction[2], direction[1])

function dijkstra_lowest_score(chart, start, finish)
    queue = [(0, start, CartesianIndex(0, 1))]  # cost, position, dir = east
    visited = Set()
    while length(queue) > 0
        _, j = findmin([q[1] for q in queue])
        cost, pos, d = queue[j]
        deleteat!(queue, j)
        pos == finish && return cost
        (pos, d) in visited && continue 
        push!(visited, (pos, d))
        if chart[pos + d] != "#"
            push!(queue, (cost+1, pos+d, d))
        end
        push!(queue, (cost+1000, pos, turn_right(d)))
        push!(queue, (cost+1000, pos, turn_left(d)))
    end
    println("No path found.")
end

chart = permutedims(hcat(split.(readlines("input/day16.txt"), "")...), (2, 1))
start  = findfirst(chart .== "S")
finish = findfirst(chart .== "E")

cost = dijkstra_lowest_score(chart, start, finish)
println("Solution 1: ", cost)