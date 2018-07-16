include("base.jl")

struct FXPair <: AbstractAsset
    """
    e.g. USD|JPY
    domestic: JPY
    foreign: USD
    """
    symbol::String
    foreign::Currency
    domestic::Currency
    FXPair(foreign::Currency, domestic::Currency) = new(string(foreign.symbol, "|", domestic.symbol), foreign, domestic)
    function FXPair(symbol::AbstractString)
        strarray = split(symbol, "|")
        foreign = Currency(strarray[1])
        domestic = Currency(strarray[2])
        new(symbol, foreign, domestic)
    end
end

valcurrency(fxp::FXPair) = fxp.domestic
invpair(fxp::FXPair) = FXPair(fxp.domestic, fxp.foreign)

struct FXForward <: AbstractAsset
    pair::FXPair
    maturity::Base.DateTime
end

invforward(fxf::FXForward) = FXForward(invpair(fxf.pair), fxf.maturity)
maturity(fxf::FXForward) = fxf.maturity

# Frequently used currencies and pairs
const USD = Currency("USD")
const JPY = Currency("JPY")
const CNY = Currency("CNY")
const EUR = Currency("EUR")

const USDJPY = FXPair(USD, JPY)
const JPYUSD = FXPair(JPY, USD)
const USDCNY = FXPair(USD, CNY)
const CNYUSD = FXPair(CNY, USD)
