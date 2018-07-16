abstract type Commission end

struct PerValue <: Commission
    value::Float64
end

struct PerTrade <:Commission
    value::Float64
end

struct PerVolume <:Commission
    value::Float64
end

commission(assetquote::Quote{T}, amount::Float64, comm::PerValue) where {T} =
    Cash(valcurrency(assetquote), amount * assetquote.value * comm.value)

commission(assetquote::Quote{T}, amount::Float64, comm::PerTrade) where {T} =
    Cash(valcurrency(assetquote), comm.value)

commission(assetquote::FXQuote, amount::Float64, comm::PerVolume) =
    Cash(foreign(assetquote), amount * comm.value)

commission(assetquote::FXForwardQuote, amount::Float64, comm::PerVolume) =
    Cash(foreign(assetquote), amount * comm.value)
