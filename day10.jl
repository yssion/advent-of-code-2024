in_bounds(chart, position) = (1 <= position[1] <= size(chart, 1) && 
                              1 <= position[2] <= size(chart, 2))

function find_trailheads(chart)
    positions = Set()
    for coord in CartesianIndices(chart)
        if chart[coord] == 0
            push!(positions, coord)
        end
    end
    return positions
end

function trail_dfs(chart, position, reachable_peaks, trail_counter)
    if chart[position] == 9
        push!(reachable_peaks, position)
        push!(trail_counter, 1)
    end
    for d in directions
        if adj[d][position] == 1
            trail_dfs(chart, d + position, reachable_peaks, trail_counter)
        end
    end
    return reachable_peaks, trail_counter
end

function assess_all_trailheads(chart, trailheads)
    score, rating = 0, 0
    for start in trailheads
        result = trail_dfs(chart, start, Set(), [])
        score  += length(result[1])
        rating += length(result[2])
    end
    return score, rating
end

chart = hcat([parse.(Int, split(line, "")) for line in readlines("input/day10.txt")]...)'
directions = CartesianIndex.([-1, 0, 1, 0], [0, 1, 0, -1])
adj = Dict([d => zeros(Int, size(chart)) for d in directions])
adj[CartesianIndex( 1, 0)][1:end-1, :] =  diff(chart, dims=1) .== 1
adj[CartesianIndex(-1, 0)][2:end, :]   = -diff(chart, dims=1) .== 1
adj[CartesianIndex( 0, 1)][:, 1:end-1] =  diff(chart, dims=2) .== 1
adj[CartesianIndex( 0,-1)][:, 2:end]   = -diff(chart, dims=2) .== 1

trailheads = find_trailheads(chart)
sol1, sol2 = assess_all_trailheads(chart, trailheads)

println("Solution 1: ", sol1)
println("Solution 2: ", sol2)