import Base.==
import Base.+
import Base.-
import Base.*
import Base./

abstract type AbstractAsset end

struct Currency <: AbstractAsset
    symbol::String
    Currency(symbol::AbstractString) = new(uppercase(symbol))
end

symbol(curr::Currency) = curr.symbol

==(lhs::Currency, rhs::Currency) = isequal(lhs.symbol, rhs.symbol)

struct Cash
    currency::Currency
    value::Float64
end

symbol(cash::Cash) = cash.currency.symbol
valcurrency(cash::Cash) = cash.currency

-(cash::Cash) = Cash(cash.currency, -cash.value)
+(lhs::Cash, rhs::Cash) = lhs.currency == rhs.currency ?
    Cash(lhs.currency, lhs.value + rhs.value) : error("Currency is not compatiable")
-(lhs::Cash, rhs::Cash) = lhs.currency == rhs.currency ?
    Cash(lhs.currency, lhs.value - rhs.value) : error("Currency is not compatiable")
*(lhs::Cash, rhs::Float64) = Cash(lhs.currency, lhs.value * rhs)
*(lhs::Float64, rhs::Cash) = Cash(rhs.currency, lhs * rhs.value)
/(lhs::Cash, rhs::Float64) = Cash(lhs.currency, lhs.value / rhs)

# Frequently used currencies and pairs
const USD = Currency("USD")
const JPY = Currency("JPY")
const EUR = Currency("EUR")
const CNY = Currency("CNY")

const BTC = Currency("BTC")
const ETH = Currency("ETH")
const EOS = Currency("EOS")
const USDT = Currency("USDT")
