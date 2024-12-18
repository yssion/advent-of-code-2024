in_bounds(chart, position) = (1 <= position[1] <= size(chart, 1) && 
                              1 <= position[2] <= size(chart, 2))

function draw_chart(chart)
    for i in axes(chart, 1)
        for j in axes(chart, 2)
            print(chart[i, j])
        end
        println()
    end
end    

function fill_memory_space!(chart, positions)
    for pos in positions
        chart[pos] = "#"
    end
end

function dijkstra_shortest_path(chart, start, finish)
    queue = [(0, start)]  # steps, position
    visited = Set()
    while !isempty(queue)
        _, j = findmin([q[1] for q in queue])
        steps, pos = queue[j]
        deleteat!(queue, j)
        pos == finish && return steps
        pos in visited && continue 
        push!(visited, pos)
        for d in directions
            if in_bounds(chart, pos + d) && chart[pos + d] != "#"
                push!(queue, (steps+1, pos+d))
            end
        end
    end
    # println("No path found.")
end

function find_inescapable(chart, start, finish)
    for (n, pos) in enumerate(positions[n_bytes+1:end])
        chart[pos] = "#"
        dijkstra_shortest_path(chart, start, finish) === nothing && return n + n_bytes
    end
end

pos_data = [parse.(Int, line) for line in split.(readlines("input/day18.txt"), ',')]
positions = [CartesianIndex(x[2] + 1, x[1] + 1) for x in pos_data]
directions = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])

n_rows, n_cols = 71, 71
n_bytes = 1024

chart = fill(".", n_rows, n_cols)
start, finish = CartesianIndex(1, 1), CartesianIndex(size(chart)...)
fill_memory_space!(chart, positions[1:n_bytes])
# draw_chart(chart)

steps = dijkstra_shortest_path(chart, start, finish)
n_inescapable = find_inescapable(chart, start, finish)

println("Solutions 1: ", steps)
println("Solutions 2: ", pos_data[n_inescapable])
