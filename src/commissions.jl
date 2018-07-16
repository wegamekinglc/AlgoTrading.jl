include("assets/assets.jl")

abstract type Commission end

struct PerValue <: Commission
    value::Float64
end

struct PerTrade <:Commission
    value::Float64
end

calcommission(assetquote::Quote{T}, comm::PerValue) where {T} =
    Cash(valcurrency(assetquote), assetquote.value * comm.value)
calcommission(assetquote::Quote{T}, comm::PerTrade) where {T} =
    Cash(valcurrency(assetquote), comm.value)
