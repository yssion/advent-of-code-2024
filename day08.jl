in_bounds(chart, position) = (1 <= position[1] <= size(chart, 1) && 
                              1 <= position[2] <= size(chart, 2))

function find_antennae(chart)
    antennae = []
    for coord in CartesianIndices(chart)
        if chart[coord] != "."
            push!(antennae, (chart[coord], coord))
        end
    end
    return antennae
end

function find_antinodes(chart, antennae; harmonics=false)
    antinodes = Set()
    for i in eachindex(antennae), j in 1:i-1
        a1, a2 = antennae[i], antennae[j]
        a1[1] != a2[1] && continue
        displacement = a2[2] - a1[2]
        if !harmonics # part 1
            if in_bounds(chart, a1[2] - displacement)
                push!(antinodes, a1[2] - displacement)
            end
            if in_bounds(chart, a2[2] + displacement)
                push!(antinodes, a2[2] + displacement)
            end
        else # part 2
            n = 0
            while in_bounds(chart, a1[2] - n*displacement)
                push!(antinodes, a1[2] - n*displacement)
                n += 1
            end
            n = 0
            while in_bounds(chart, a2[2] + n*displacement)
                push!(antinodes, a2[2] + n*displacement)
                n += 1
            end
        end
    end
    return antinodes
end

chart = permutedims(hcat(split.(readlines("input/day08.txt"), "")...), (2, 1))
sol1 = length(find_antinodes(chart, find_antennae(chart)))
sol2 = length(find_antinodes(chart, find_antennae(chart), harmonics=true))

println("Solution 1: ", sol1)
println("Solution 2: ", sol2)