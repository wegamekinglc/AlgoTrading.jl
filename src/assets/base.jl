import Base.==

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
