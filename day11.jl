function blink!(counter)
    current_counter = copy(counter)
    for (stone, num) in current_counter
        num == 0 && continue
        if stone == 0
            haskey(counter, 1) ? counter[1] += num : counter[1] = num
        elseif length(string(stone)) % 2 == 0
            s1 = parse(Int, string(stone)[1:div(end,2)])
            s2 = parse(Int, string(stone)[div(end,2)+1:end])
            haskey(counter, s1) ? counter[s1] += num : counter[s1] = num
            haskey(counter, s2) ? counter[s2] += num : counter[s2] = num
        else
            haskey(counter, stone*2024) ? counter[stone*2024] += num : counter[stone*2024] = num
        end
        counter[stone] -= num
    end
end

stones = parse.(Int, split.(readlines("input/day11.txt"))[1])
counter = Dict([stone => count(stones .== stone) for stone in Set(stones)])

[blink!(counter) for _ in 1:25]
println("Solution 1: ", sum(values(counter)))

[blink!(counter) for _ in 1:50]
println("Solution 2: ", sum(values(counter)))