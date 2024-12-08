function check_N(grid, i, j, word)
    len = length(word)
    i < len && return false
    return join(grid[i:-1:i-(len-1), j]) == word
end

function check_S(grid, i, j, word)
    len = length(word)
    i > grid.size[1] - (len-1) && return false
    return join(grid[i:i+(len-1), j]) == word
end

function check_E(grid, i, j, word)
    len = length(word)
    j > grid.size[2] - (len-1) && return false
    return join(grid[i, j:j+(len-1)]) == word
end

function check_W(grid, i, j, word)
    len = length(word)
    j < len && return false
    return join(grid[i, j:-1:j-(len-1)]) == word
end

function check_NE(grid, i, j, word)
    len = length(word)
    (i < len || j > grid.size[2] - (len-1)) && return false
    return join(grid[i-k, j+k] for k=0:len-1) == word
end

function check_NW(grid, i, j, word)
    len = length(word)
    (i < len || j < len) && return false
    return join(grid[i-k, j-k] for k=0:len-1) == word
end

function check_SE(grid, i, j, word)
    len = length(word)
    (i > grid.size[1] - (len-1) || j > grid.size[2] - (len-1)) && return false
    return join(grid[i+k, j+k] for k=0:len-1) == word
end

function check_SW(grid, i, j, word)
    len = length(word)
    (i > grid.size[1] - (len-1) || j < len) && return false
    return join(grid[i+k, j-k] for k=0:len-1) == word
end

function check_all_dir(grid, i, j; word="XMAS")
    compass = [check_N, check_E, check_S, check_W, 
               check_NE, check_NW, check_SE, check_SW]
    return sum(check(grid, i, j, word) for check in compass)
end

function check_for_cross(grid, i, j; word="MAS")
    return (check_SE(grid, i, j, word) || check_NW(grid, i+2, j+2, word)) &&
           (check_NE(grid, i+2, j, word) || check_SW(grid, i, j+2, word))
end

data = hcat(split.(readlines("input/day04.txt"), "")...)
sol1 = sum([check_all_dir(data, i, j) for i=1:data.size[1], j=1:data.size[2]])
sol2 = sum([check_for_cross(data, i, j) for i=1:data.size[1]-2, j=1:data.size[2]-2])

println("Solution 1: ", sol1)
println("Solution 2: ", sol2)