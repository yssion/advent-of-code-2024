function draw_chart(chart)
    for i in axes(chart, 1)
        for j in axes(chart, 2)
            print(chart[i, j])
        end
        println()
    end
end    

function step!(chart, move; pos=nothing)
    if pos === nothing
        pos = findfirst(chart .== "@")
    else
        chart[pos] != "@" && throw("Incorrect current position.")
    end
    move = directions[move]
    # Robot hits wall
    chart[pos + move] == "#" && return pos
    # Robot moves to empty cell
    if chart[pos + move] == "."
        chart[pos] = "."
        chart[pos + move] = "@"
        return pos + move
    end
    # Robots moves n boxes
    n = 1
    while chart[pos + n*move] == "O"
        n += 1
    end
    chart[pos + n*move] == "#" && return pos 
    chart[pos + n*move] = "O"
    chart[pos + move] = "@"
    chart[pos] = "."
    return pos + move
end

function n_steps!(chart, moves; pos=nothing, draw=false)
    for move in moves
        pos = step!(chart, move, pos=pos)
    end
    draw && draw_chart(chart)
    return pos
end

function sum_box_gps(chart; doubled=false)
    total = 0
    for i in CartesianIndices(chart)
        if (!doubled && chart[i] == "O") || (doubled && chart[i] == "[")
            total += 100*(i[1] - 1) + (i[2] - 1)
        end
    end
    return total
end

function resized_warehouse(chart)
    new_chart = Array{String}(undef, size(chart, 1), 2*size(chart, 2))
    di = CartesianIndex(0, 1)
    for i in CartesianIndices(chart)
        j = CartesianIndex(i[1], 2*(i[2]-1)+1)
        println(j)
        if chart[i] == "#"
            new_chart[j:j+di] .= "#"
        elseif chart[i] == "."
            new_chart[j:j+di] .= "."
        elseif chart[i] == "O"
            new_chart[j] = "["
            new_chart[j+di] = "]"
        elseif chart[i] == "@"
            new_chart[j] = "@"
            new_chart[j+di] = "."
        end
    end
    return new_chart
end

function new_step!(chart, move; pos=nothing)
    if pos === nothing
        pos = findfirst(chart .== "@")
    else
        chart[pos] != "@" && throw("Incorrect current position.")
    end
    move = directions[move]
    # Robot hits wall
    chart[pos + move] == "#" && return pos
    # Robot moves to empty cell
    if chart[pos + move] == "."
        chart[pos] = "."
        chart[pos + move] = "@"
        return pos + move
    end
    # Robots moves boxes
    n = 1
    boxes = Set(pos + move)
    while chart[pos + n*move] in ("[", "]")
        n += 1
    end
    chart[pos + n*move] == "#" && return pos 
    chart[pos + n*move] = "O"
    chart[pos + move] = "@"
    chart[pos] = "."
    return pos + move
end


data = readlines("input/day15.txt")
sep = findfirst(data .== "")
chart = permutedims(hcat(split.(data[1:sep-1], "")...), (2, 1))
route = join(data[sep+1:end])
directions = Dict('^' => CartesianIndex(-1, 0), '>' => CartesianIndex(0,  1), 
                  'v' => CartesianIndex( 1, 0), '<' => CartesianIndex(0, -1))

n_steps!(chart, route)
println("Solution 1: ", sum_box_gps(chart))

new_chart = resized_warehouse(chart)
draw_chart(new_chart)