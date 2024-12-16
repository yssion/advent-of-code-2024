using Plots

periodic_bc(x, width, height) = [mod(x[1], width), mod(x[2], height)]
new_positions(t, x, v, width, height) = periodic_bc.(x .+ v.*t, width, height)
safety_factor(quadrants) = reduce(*, map(x -> count(quadrants .== x), 1:4))

function which_quadrant(position, width, height)
    p = (position .- [div(width, 2), div(height, 2)])
    any(p .== 0) && return 0
    p[1] < 0 && p[2] < 0 && return 1
    p[1] > 0 && p[2] < 0 && return 2
    p[1] < 0 && p[2] > 0 && return 3
    p[1] > 0 && p[2] > 0 && return 4
end

function draw(positions, width, height; t="")
    im = zeros(width, height)
    for i in 1:width, j in 1:height
        im[i, j] = [i, j] in positions
    end
    return heatmap(im', aspect_ratio=1, title="Timestep $t", yflip = true)
end

data = [split(line, (',', ' ')) for line in readlines("input/day14.txt")]
pos = [[parse(Int, line[1][3:end]), parse(Int, line[2])] for line in data]
vel = [[parse(Int, line[3][3:end]), parse(Int, line[4])] for line in data]
width, height = 101, 103

# Part 1
t = 100
x = new_positions(t, pos, vel, width, height)
quadrants = which_quadrant.(x, width, height)
println("Solution 1: ", safety_factor(quadrants))

# Part 2
start, stop = 1, 101*103
dt = 1
timesteps = start:dt:stop
safety = zeros(length(timesteps))
for (i, t) in enumerate(timesteps)
    x = new_positions(t, pos, vel, width, height)
    safety[i] = safety_factor(which_quadrant.(x, width, height))
end
plot(timesteps, safety, legend=:topright)


# for t in 27+101*75:101:101*103
#     x = new_positions(t, pos, vel, width, height)
#     fig = draw(x, width, height, t=t)
#     display(fig)
#     sleep(1)
# end

t = 8006
x = new_positions(t, pos, vel, width, height)
fig = draw(x, width, height, t=t)
display(fig)