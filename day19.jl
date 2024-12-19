using Memoize

@memoize function count_possibilities(design)
    design == "" && return 1
    possibilities = [count_possibilities(design[length(p)+1:end]) 
                     for p in patterns if startswith(design, p)]
    isempty(possibilities) && return 0
    return sum(possibilities)
end

file = "input/day19.txt"
patterns = split(readlines(file)[1], ", ")
designs = readlines(file)[3:end]

v = [count_possibilities(design) for design in designs]

println("Solutions 1: ", count(v .!= 0))
println("Solutions 2: ", sum(v))