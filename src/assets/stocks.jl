include("base.jl")

struct Stock <: AbstractAsset
    symbol::String
    currency::Currency
end

valcurrency(stock::Stock) = stock.currency
