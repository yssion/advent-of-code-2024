function fill_free_block!(block_length, files)
    """Returns vector with ids that fills free block of length block_length
    and removes corresponding files from the vector files. For part 1."""
    id = length(files)
    block = []
    i = 1
    while block_length > 0 && id > 0
        if files[id] == 0
            id -= 1
            continue
        end
        push!(block, id)
        files[id] -= 1
        i += 1
        block_length -= 1
    end
    return block .- 1  # zero-indexing of file ids
end

function compact_diskmap(diskmap; fragment=true)
    """Give list of file blocks and free space blocks, returns compacted files
    in long format."""
    files = diskmap[1:2:end]
    free  = diskmap[2:2:end]
    compacted = zeros(Int, sum(diskmap))
    if fragment  # part 1
        k = 1  # counter for compacted
        for id in eachindex(files)
            compacted[k:k+files[id]-1] .= id - 1  # zero-indexing
            k += files[id]
            files[id] = 0
            if id <= length(free)
                block = fill_free_block!(free[id], files)
                compacted[k:k+length(block)-1] = block
                k += free[id]
                free[id] > length(block) && continue
            end
        end
        return compacted
    end
    # Part 2
    new_free = copy(free)
    for id in reverse(eachindex(files))
        fs = findfirst(0 < files[id] .<= new_free)  # free space to move to
        (fs === nothing || fs >= id) && continue
        k = sum(diskmap[1:2*(fs-1)+1]) + (free[fs] - new_free[fs]) + 1
        compacted[k:k+files[id]-1] .= id - 1  # zero-indexing
        new_free[fs] -= files[id]
        files[id] = 0 
    end
    for id in eachindex(files)
        files[id] == 0 && continue
        k = sum(diskmap[1:2*(id-1)]) + 1
        compacted[k:k+files[id]-1] .= id - 1
    end
    return compacted
end

diskmap = [parse(Int, i) for i in readlines("input/day09.txt")[1]]
compacted1 = compact_diskmap(diskmap)
compacted2 = compact_diskmap(diskmap, fragment=false)

println("Solution 1: ", sum(compacted1[i]*(i-1) for i in eachindex(compacted1)))
println("Solution 2: ", sum(compacted2[i]*(i-1) for i in eachindex(compacted2)))