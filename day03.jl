function str_to_product(str)
    x = parse(Int, split(str, ',')[1][5:end])
    y = parse(Int, split(str, ',')[2][1:end-1])
    x * y
end

data = join(readlines("input/day03.txt"))
pattern = r"mul\([0-9]+,[0-9]+\)"

matches = [m.match for m = eachmatch(pattern, data)]
sol1 = sum(str_to_product.(matches))

do_data = replace(replace(data, r"don't\(\)(.*?)do\(\)" => ""), 
                    r"don't\(\)(.*?)" => "")
do_matches = [m.match for m = eachmatch(pattern, do_data)]
sol2 = sum(str_to_product.(do_matches))

println("Solution 1: ", sol1)
println("Solution 2: ", sol2)