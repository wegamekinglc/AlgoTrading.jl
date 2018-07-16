include("base.jl")

import Base.==

struct FXPair <: AbstractAsset
    """
    e.g. USD|JPY
    domestic: JPY
    foreign: USD
    """
    symbol::String
    foreign::Currency
    domestic::Currency
    FXPair(foreign::Currency, domestic::Currency) =
        new(string(foreign.symbol, "|", domestic.symbol), foreign, domestic)
    function FXPair(symbol::AbstractString)
        strarray = split(symbol, "|")
        foreign = Currency(strarray[1])
        domestic = Currency(strarray[2])
        new(symbol, foreign, domestic)
    end
end

==(lhs::FXPair, rhs::FXPair) = isequal(lhs.symbol, rhs.symbol)

domestic(fxp::FXPair) = fxp.domestic
foreign(fxp::FXPair) = fxp.foreign
valcurrency(fxp::FXPair) = fxp.domestic
invpair(fxp::FXPair) = FXPair(fxp.domestic, fxp.foreign)

struct FXForward <: AbstractAsset
    pair::FXPair
    maturity::Base.DateTime
end

invforward(fxf::FXForward) = FXForward(invpair(fxf.pair), fxf.maturity)
domestic(fxf::FXForward) = fxf.pair.domestic
foreign(fxf::FXForward) = fxf.pair.foreign
valcurrency(fxf::FXForward) = foreign(fxf)
maturity(fxf::FXForward) = fxf.maturity

if !isdefined(:USDJPY)
    const USDJPY = FXPair(USD, JPY)
end

if !isdefined(:JPYUSD)
    const JPYUSD = FXPair(JPY, USD)
end

if !isdefined(:USDCNY)
    const USDCNY = FXPair(USD, CNY)
end

if !isdefined(:CNYUSD)
    const CNYUSD = FXPair(CNY, USD)
end
