function fill_free_block!(block_length, files)
    """Returns vector with ids that fills free block of length block_length
    and removes corresponding files from the vector files"""
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

function compact_diskmap(diskmap)
    """Give list of file blocks and free space blocks, returns compacted files
    in sparse format."""
    files = diskmap[1:2:end]
    free  = diskmap[2:2:end]
    compacted = zeros(Int, sum(diskmap))
    k = 1  # counter for compacted
    for id in eachindex(files)
        compacted[k:k+files[id]-1] .= id - 1  # zero-indexing
        k += files[id]
        files[id] = 0
        if id <= length(free)
            block = fill_free_block!(free[id], files)
            compacted[k:k+length(block)-1] = block
            k += free[id]
            if free[id] > length(block)
                continue
            end
        end
    end
    return compacted
end

diskmap = [parse(Int, i) for i in readlines("input/day09.txt")[1]]
compacted = compact_diskmap(diskmap)
println("Solution 1: ", sum(compacted[i] * (i-1) for i in eachindex(compacted)))