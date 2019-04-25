emp(::T) where {T <: Array}
emp(::T) where {T <: Array}

"Pqarnts of `rv` wrt `ω`: RandVars executed in execution of rv(ω)"
function parents(ω, rv, ::Type{T} = Set{RandVar}) where {T}
  rv(ω)
  col = emp(T)
  for id in keys(ω)
    push!(col, id)
  end
end
@pre isstateful(ω)