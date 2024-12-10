in_bounds(chart, position) = (1 <= position[1] <= size(chart, 1) && 
                              1 <= position[2] <= size(chart, 2))
is_obstruction(chart, position) = chart[position] == "#"
turn_right(direction) = CartesianIndex(direction[2], -direction[1])

function find_route!(chart, position, direction)
    visited = Set()
    while true
        chart[position] = "X"
        push!(visited, (position, direction))
        !in_bounds(chart, position + direction) && break
        (position + direction, direction) in visited && break
        if is_obstruction(chart, position + direction)
            direction = turn_right(direction)
            push!(visited, (position, direction))
            continue
        end
        position += direction
    end
    return visited
end

function in_loop(chart, position, direction, object)
    visited = Set()
    while true
        push!(visited, (position, direction))
        !in_bounds(chart, position + direction) && return false
        (position + direction, direction) in visited && return true
        if (is_obstruction(chart, position + direction) || 
            position + direction == object)
            direction = turn_right(direction)
            push!(visited, (position, direction))
            continue
        end
        position += direction
    end
end

function find_obstacle_locations(chart, visited, position, direction)
    obstacle_locations = Set()
    for step in visited
        obstacle = sum(step)
        !in_bounds(chart, obstacle) && continue
        if in_loop(chart, position, direction, obstacle)
            push!(obstacle_locations, obstacle)
        end
    end
    return obstacle_locations
end

chart = permutedims(hcat(split.(readlines("input/day06.txt"), "")...), (2, 1))
position = CartesianIndex(findfirst(x -> x=="^", chart))
direction = CartesianIndex(-1, 0)

visited = find_route!(chart, position, direction)
sol1 = count(x -> x=="X", chart)
println("Solution 1: ", sol1)

sol2 = length(find_obstacle_locations(chart, visited, position, direction))
println("Solution 2: ", sol2)