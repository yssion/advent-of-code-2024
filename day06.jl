check_in_bounds(chart, x, y) = (1 <= x <= chart.size[1] && 
                                1 <= y <= chart.size[2])
check_for_obstruction(chart, x, y) = chart[x, y] == "#"
turn_right(direction) = (direction[2], -direction[1])

function find_route!(chart)
    # Initial conditions
    x, y = Tuple(findfirst(x -> x=="^", chart))
    direction = [-1, 0] #[0, 1] [1, 0] [0, -1]
    # Walk
    while true
        chart[x, y] = "X"
        !check_in_bounds(chart, x + direction[1], y + direction[2]) && break
        if check_for_obstruction(chart, x + direction[1], y + direction[2])
            direction = turn_right(direction)
            continue
        end
        x += direction[1]
        y += direction[2]
    end
end

chart = permutedims(hcat(split.(readlines("input/day06.txt"), "")...), (2, 1))
# chart = permutedims(hcat(split.(readlines("input/test2.txt"), "")...), (2, 1))
find_route!(chart)
sol1 = count(x -> x=="X", chart)

println("Solution 1: ", sol1)