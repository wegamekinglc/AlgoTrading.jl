struct Stock <: AbstractAsset
    symbol::String
    currency::Currency
end

symbol(stock::Stock) = stock.symbol
valcurrency(stock::Stock) = stock.currency
