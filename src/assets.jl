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

struct FXPair
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

struct FXQuote
    pair::FXPair
    value::Float64
end

+(lhs::Cash, rhs::Cash) = lhs.currency == rhs.currency ? Cash(lhs.currency, lhs.value + rhs.value) : error("Currency is not compatiable")
-(lhs::Cash, rhs::Cash) = lhs.currency == rhs.currency ? Cash(lhs.currency, lhs.value - rhs.value) : error("Currency is not compatiable")
*(lhs::Cash, rhs::Float64) = Cash(lhs.currency, lhs.value * rhs)
*(lhs::Float64, rhs::Cash) = Cash(rhs.currency, lhs * rhs.value)
/(lhs::Cash, rhs::Float64) = Cash(lhs.currency, lhs.value / rhs)

function *(lhs::FXQuote, rhs::FXQuote)
    if lhs.pair.domestic == rhs.pair.foreign
        FXQuote(FXPair(lhs.pair.foreign, rhs.pair.domestic), lhs.value * rhs.value)
    elseif lhs.pair.foreign == rhs.pair.domestic
        FXQuote(FXPair(rhs.pair.foreign, lhs.pair.domestic), lhs.value * rhs.value)
    else
        error("Currency is not compatiable")
    end
end

function /(lhs::FXQuote, rhs::FXQuote)
    if lhs.pair.domestic == rhs.pair.domestic
        FXQuote(FXPair(lhs.pair.foreign, rhs.pair.foreign), lhs.value / rhs.value)
    elseif lhs.pair.foreign == rhs.pair.foreign
        FXQuote(FXPair(rhs.pair.domestic, lhs.pair.domestic), lhs.value / rhs.value)
    else
        error("Currency is not compatiable")
    end
end

/(lhs::FXQuote, rhs::Float64) = FXQuote(lhs.pair, lhs.value / rhs)
/(lhs::Float64, rhs::FXQuote) = FXQuote(FXPair(rhs.pair.domestic, rhs.pair.foreign), lhs / rhs.value)

*(lhs::FXQuote, rhs::Cash) = lhs.pair.foreign == rhs.currency ? Cash(lhs.pair.domestic, lhs.value * rhs.value) : error("Currency is not compatiable")
*(lhs::Cash, rhs::FXQuote) = lhs.currency == rhs.pair.foreign ? Cash(rhs.pair.domestic, lhs.value * rhs.value) : error("Currency is not compatiable")

# Frequently used currencies and pairs
USD = Currency("USD")
JPY = Currency("JPY")
CNY = Currency("CNY")
EUR = Currency("EUR")

USDJPY = FXPair(USD, JPY)
JPYUSD = FXPair(JPY, USD)
USDCNY = FXPair(USD, CNY)
CNYUSD = FXPair(CNY, USD)
