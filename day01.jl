using DelimitedFiles

function similarity_score(v1, v2)
    score = 0
    index = 1
    for n1 in v1
        n2 = v2[index]
        while n1 > n2 && index < length(v2)
            index += 1
            n2 = v2[index]
        end
        while n1 == n2 && index < length(v2)
            score += n1
            index += 1
            n2 = v2[index]
        end
    end
    return score
end

m = sort(readdlm("input/day01.txt", Int), dims=1)
println("Solution 1: ", sum(abs.(diff(m, dims=2))))
println("Solution 2: ", similarity_score(m[:, 1], m[:, 2]))