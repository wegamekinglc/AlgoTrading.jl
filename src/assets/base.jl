import Base.==
import Base.+
import Base.-
import Base.*
import Base./

abstract type AbstractAsset end

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

+(lhs::Cash, rhs::Cash) = lhs.currency == rhs.currency ? Cash(lhs.currency, lhs.value + rhs.value) : error("Currency is not compatiable")
-(lhs::Cash, rhs::Cash) = lhs.currency == rhs.currency ? Cash(lhs.currency, lhs.value - rhs.value) : error("Currency is not compatiable")
*(lhs::Cash, rhs::Float64) = Cash(lhs.currency, lhs.value * rhs)
*(lhs::Float64, rhs::Cash) = Cash(rhs.currency, lhs * rhs.value)
/(lhs::Cash, rhs::Float64) = Cash(lhs.currency, lhs.value / rhs)

# Frequently used currencies and pairs
if !isdefined(:USD)
    const USD = Currency("USD")
end

if !isdefined(:JPY)
    const JPY = Currency("JPY")
end

if !isdefined(:EUR)
    const EUR = Currency("EUR")
end

if !isdefined(:CNY)
    const CNY = Currency("CNY")
end
