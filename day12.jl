in_bounds(chart, position) = (1 <= position[1] <= size(chart, 1) && 
                              1 <= position[2] <= size(chart, 2))

function fencing_cost(garden)
    cost, visited = 0, falses(size(garden))
    for i in CartesianIndices(garden)
        visited[i] && continue
        bonds, queue, cluster = 0, Set([i]), Set()
        while !isempty(queue)
            j = pop!(queue)
            visited[j] = true
            push!(cluster, j)
            for d in directions
                !in_bounds(garden, j + d) && continue
                if garden[j + d] == garden[i]
                    bonds += 1
                    if !(j + d in cluster)
                        push!(queue, j + d)
                    end
                end
            end
        end
        area = length(cluster)
        perimeter = 4 * area - bonds
        cost += perimeter * area
    end
    return cost
end

garden = hcat([split(line, "") for line in readlines("input/day12.txt")]...)
directions = CartesianIndex.([(-1, 0), (0, 1), (1, 0), (0, -1)])

println("Solution 1: ", fencing_cost(garden))