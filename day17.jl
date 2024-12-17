function adv!(register, op, pointer, out)
    register['A'] = div(register['A'], 2^combo_operand(op))
    return pointer + 2
end

function bxl!(register, op, pointer, out)
    register['B'] = xor(register['B'], op)
    return pointer + 2
end

function bst!(register, op, pointer, out)
    register['B'] = mod(combo_operand(op), 8)
    return pointer + 2
end

function jnz!(register, op, pointer, out)
    register['A'] == 0 && return pointer + 2
    return op
end

function bxc!(register, op, pointer, out)
    register['B'] = xor(register['B'], register['C'])
    return pointer + 2
end

function out!(register, op, pointer, out)
    push!(out, mod(combo_operand(op), 8))
    return pointer + 2
end

function bdv!(register, op, pointer, out)
    register['B'] = div(register['A'], 2^combo_operand(op))
    return pointer + 2
end

function cdv!(register, op, pointer, out)
    register['C'] = div(register['A'], 2^combo_operand(op))
    return pointer + 2
end

function combo_operand(num)
    0 <= num <= 3 && return num
    num == 4 && return register['A']
    num == 5 && return register['B']
    num == 6 && return register['C']
    num == 7 && return nothing
end

function run_program!(instructions, register)
    output = []
    pointer = 0
    counter = 1
    while 0 <= pointer <= length(instructions) - 2
        opcode = instructions[pointer + 1]
        operand = instructions[pointer + 2]
        pointer = opcodes[opcode](register, operand, pointer, output)
        counter += 1
    end
    return join(string.(output), ',')
end

opcodes = Dict(0 => adv!, 1 => bxl!, 2 => bst!, 3 => jnz!, 
               4 => bxc!, 5 => out!, 6 => bdv!, 7 => cdv!)

input = readlines("input/day17.txt")
register = Dict('A' => parse.(Int, input[1][13:end]), 
                'B' => parse.(Int, input[2][13:end]), 
                'C' => parse.(Int, input[3][13:end]))
instructions = parse.(Int, split(input[5][10:end], ','))

out = run_program!(instructions, register)
println("Solution 1: ", out)