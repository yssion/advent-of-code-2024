data = readlines("input/day05.txt")
sep = findfirst(data .== "")
rules = stack([parse.(Int, split(data[i], '|')) for i=1:sep-1], dims=1)
updates = [parse.(Int, split(data[i], ',')) for i=sep+1:length(data)]

is_before(x, y) = any([x, y] == rules[i, 1:2] for i in 1:rules.size[1])
is_ordered(v) = all(is_before(v[i], v[j]) for j in eachindex(v) for i=1:j-1)

# Unwanted update entries are set to zero for summation
valid_updates = [is_ordered(update) for update in updates]
sol1 = sum(update[div(length(update)+1, 2)] for update in valid_updates .* updates)

newly_sorted = [sort(update, lt=is_before) for update in (valid_updates .== 0) .* updates]
sol2 = sum(update[div(length(update)+1, 2)] for update in newly_sorted)

println("Solution 1: ", sol1)
println("Solution 2: ", sol2)