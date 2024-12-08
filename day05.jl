function is_ordered(rules, update)
    for (i, page) in enumerate(update)
        before = rules[findall(rules[:, 2] .== page), 1]
        any(n in update[i:end] for n in before) && return false
    end
    return true
end

function reorder(rules, update)
    # identify which entries are problematic

end

data = readlines("input/test.txt")
# data = readlines("input/day05.txt")
sep = findfirst(data .== "")
rules = stack([parse.(Int, split(data[i], '|')) for i=1:sep-1], dims=1)
updates = [parse.(Int, split(data[i], ',')) for i=sep+1:length(data)]

# Changes all invalid updates to list of zeroes and then sum middle entries
valid_updates = [is_ordered(rules, update) for update in updates] .* updates
sol1 = sum(update[div(length(update)+1, 2)] for update in valid_updates)

for update in updates
    if !is_ordered(rules, update)
        new = reorder(rules, update)
    end
end

println("Solution 1: ", sol1)
# println("Solution 2: ", sol2)