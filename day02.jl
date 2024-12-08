function is_safe(report; dampen=false)
    dlevels = diff(report)
    safe = all(x -> x*dlevels[1] > 0 && 1 <= abs(x) <= 3, dlevels)
    safe && return true
    # Part 1
    ! dampen && return safe
    # Part 2
    return any(is_safe(report[1:end .!=i]) for i in eachindex(report))
end

data = readlines("input/day02.txt")
sol1 = sum((is_safe(parse.(Int, split(line))) for line in data))
sol2 = sum((is_safe(parse.(Int, split(line)), dampen=true) for line in data))

println("Solution 1: ", sol1)
println("Solution 2: ", sol2)