function read_input()
    raw = split.(readlines("input/day13.txt"))
    num_machines = Int((length(raw) + 1) / 4)
    buttons = zeros(Int, 2, 2, num_machines)
    targets = zeros(Int, 2, 1, num_machines)
    for i in 0:num_machines-1
        buttons[1, 1, i+1] = parse(Int, raw[4*i+1][3][3:end-1])
        buttons[2, 1, i+1] = parse(Int, raw[4*i+1][4][3:end])
        buttons[1, 2, i+1] = parse(Int, raw[4*i+2][3][3:end-1])
        buttons[2, 2, i+1] = parse(Int, raw[4*i+2][4][3:end])
        targets[1, 1, i+1] = parse(Int, raw[4*i+3][2][3:end-1])
        targets[2, 1, i+1] = parse(Int, raw[4*i+3][3][3:end])
    end
    return buttons, targets
end

solve_moves(buttons, targets) = inv(buttons) * targets

function part1(buttons, targets; error_correction=false, tol=1e-8)
    targets .+= error_correction * 10000000000000
    prizes = 0
    tokens = 0
    for i in axes(targets, 3)
        sol = solve_moves(buttons[:, :, i], targets[:, :, i])
        if (any(sol .< 0) || (!error_correction && any(sol .> 100)) || 
            any(abs.(sol - round.(Int, sol)) .> tol))
            continue
        end
        prizes += 1
        tokens += sum(round.(Int, sol) .* [3; 1])
    end
    return prizes, tokens
end

buttons, targets = read_input()
prizes1, tokens1 = part1(buttons, targets)
prizes2, tokens2 = part1(buttons, targets, error_correction=true, tol=1e-4)

println("Solution 1: ", tokens1, " tokens (for $prizes1 prizes)")
println("Solution 2: ", tokens2, " tokens (for $prizes2 prizes)")
