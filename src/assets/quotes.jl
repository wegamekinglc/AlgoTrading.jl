import Base.*
import Base./

include("stocks.jl")
include("fxs.jl")

struct Quote{T <: AbstractAsset}
    asset::T
    value::Float64
end

const StockQuote = Quote{Stock}
const FXQuote = Quote{FXPair}
const FXForwardQuote = Quote{FXForward}

asset(assetquote::Quote{T}) where {T} = assetquote.asset
valcurrency(assetquote::Quote{T}) where {T} = valcurrency(asset(assetquote))
domestic(fxquote::FXQuote) = fxquote.asset.domestic
foreign(fxquote::FXQuote) = fxquote.asset.foreign

function *(lhs::FXQuote, rhs::FXQuote)
    if domestic(lhs) == foreign(rhs)
        FXQuote(FXPair(foreign(lhs), domestic(rhs)), lhs.value * rhs.value)
    elseif foreign(lhs) == domestic(rhs)
        FXQuote(FXPair(domestic(lhs), foreign(rhs)), lhs.value * rhs.value)
    else
        error("Currency is not compatiable")
    end
end

function /(lhs::FXQuote, rhs::FXQuote)
    if domestic(lhs) == domestic(rhs)
        FXQuote(FXPair(foreign(lhs), foreign(rhs)), lhs.value / rhs.value)
    elseif foreign(lhs) == foreign(rhs)
        FXQuote(FXPair(domestic(lhs), domestic(rhs)), lhs.value / rhs.value)
    else
        error("Currency is not compatiable")
    end
end

/(lhs::FXQuote, rhs::Float64) = FXQuote(lhs.pair, lhs.value / rhs)
/(lhs::Float64, rhs::FXQuote) = FXQuote(FXPair(domestic(rhs), foreign(rhs)), lhs / rhs.value)

*(lhs::FXQuote, rhs::Cash) = foreign(lhs) == rhs.currency ? Cash(domestic(lhs), lhs.value * rhs.value) : error("Currency is not compatiable")
*(lhs::Cash, rhs::FXQuote) = lhs.currency == foreign(rhs) ? Cash(domestic(rhs), lhs.value * rhs.value) : error("Currency is not compatiable")

/(lhs::FXForwardQuote, rhs::Float64) = FXForwardQuote(asset(lhs), lhs.value / rhs)
/(lhs::Float64, rhs::FXForwardQuote) = FXForwardQuote(invforward(asset(rhs)), lhs / rhs.value)
