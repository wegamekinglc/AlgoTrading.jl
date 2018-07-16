import Base.==
import Base.+
import Base.-
import Base.*
import Base./

struct Currency
    symbol::String
    Currency(symbol::AbstractString) = new(uppercase(symbol))
end

==(lhs::Currency, rhs::Currency) = isequal(lhs.symbol, rhs.symbol)

struct Cash
    currency::Currency
    value::Float64
end

valcurrency(cash::Cash) = cash.currency

abstract type AbstractAsset end

struct Stock <: AbstractAsset
    symbol::String
    currency::Currency
end

valcurrency(stock::Stock) = stock.currency

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

+(lhs::Cash, rhs::Cash) = lhs.currency == rhs.currency ? Cash(lhs.currency, lhs.value + rhs.value) : error("Currency is not compatiable")
-(lhs::Cash, rhs::Cash) = lhs.currency == rhs.currency ? Cash(lhs.currency, lhs.value - rhs.value) : error("Currency is not compatiable")
*(lhs::Cash, rhs::Float64) = Cash(lhs.currency, lhs.value * rhs)
*(lhs::Float64, rhs::Cash) = Cash(rhs.currency, lhs * rhs.value)
/(lhs::Cash, rhs::Float64) = Cash(lhs.currency, lhs.value / rhs)

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

# Frequently used currencies and pairs
const USD = Currency("USD")
const JPY = Currency("JPY")
const CNY = Currency("CNY")
const EUR = Currency("EUR")

const USDJPY = FXPair(USD, JPY)
const JPYUSD = FXPair(JPY, USD)
const USDCNY = FXPair(USD, CNY)
const CNYUSD = FXPair(CNY, USD)
