"""
    splitby(condition, array) -> arrays

Splits the passed array into subarrays starting from each element that meets the condition.

# Examples
```jldoctest
julia> splitby(x->x>3, [1, 3, 4, 3, 5, 1], keep=true)
3-element Vector{Vector}:
 [1, 3]
 [4, 3]
 [5, 1]

julia> splitby(==(""), ["first", "second", "", "forth", "fifth"])
2-element Vector{Vector}:
 ["first", "second"]
 ["forth", "fifth"]
```

**Note**: It is a bit slow
"""
function splitby(condition::Function, array::Vector; keep=false)::Vector{Vector}
    indices = [[1]; findall(condition, array)]

    ret = [[array[(indices[i]+((keep || i == 1) ? 0 : 1)):indices[i+1]-1] for i in 1:(length(indices)-1)]; [array[indices[end]+(keep ? 0 : 1):end]]]

    if isempty(ret[end])
        pop!(ret)
    end
    return ret
end