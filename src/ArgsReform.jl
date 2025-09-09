module ArgsReform

macro reform(ex)
    @assert ex.head==:(=)
    @assert length(ex.args)==2
    l_ex=ex.args[1]
    r_ex=ex.args[2]

    l_args = (l_ex isa Expr && l_ex.head==:tuple) ? l_ex.args : [l_ex]
    r_args = (r_ex isa Expr && r_ex.head==:tuple) ? r_ex.args : [r_ex]

    n=l_args |> length |> Base.OneTo
    mask=(x -> x isa Expr && x.head==:(...)).(l_args)
    new_ex_1=Any[mask[i] ? (l_args[i].args|>only) : (l_args[i]) for i in n]
    new_ex_2=Any[l_args...]
    new_ex_3=Any[mask[i] ? (:(NamedTuple($(l_args[i].args|>only)))) : (l_args[i]) for i in n]
    new_ex_4=Any[(sub_ex isa Symbol) ? (:($(sub_ex)=$(sub_ex))) : sub_ex for sub_ex in r_args]

    if !(any(mask))
        push!(new_ex_1,:(_rest))
        push!(new_ex_2,:(_rest...))
        push!(new_ex_3,:(NamedTuple(_rest)))
    end

    return esc(:(($(new_ex_1...),)=((;$(new_ex_2...))->($(new_ex_3...),))(;$(new_ex_4...))))
end

end # module ArgsReform
