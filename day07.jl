function concat(a, b)
    return parse(Int, string(a) * string(b))
end

function operate(numbers, ops)
    length(ops) == 1 && return ops[1](numbers...)
    return ops[end](operate(numbers[1:end-1], ops[1:end-1]), numbers[end])
end

function check_single_calibration(line, operations)
    test_value = line[1]
    n_ops = length(line) - 2
    eqs = reverse.(Iterators.product(fill(0:length(operations)-1, n_ops)...))[:]
    eqs = [get.([operations], eq, "na") for eq in eqs]
    for eq in eqs
        test_value == operate(line[2:end], eq) && return true
    end
    return false
end

function total_calibration_result(data, operations)
    total = 0
    for line in data 
        if check_single_calibration(line, operations) 
            total += line[1]
        end
    end
    return total
end

data = [parse.(Int, split(line, (' ', ':'), keepempty=false)) 
            for line in readlines("input/day07.txt")]

ops1 = Dict(0 => +, 1 => *)
ops2 = Dict(0 => +, 1 => *, 2 => concat)

println("Solution 1: ", total_calibration_result(data, ops1))
println("Solution 2: ", total_calibration_result(data, ops2))