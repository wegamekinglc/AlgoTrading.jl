module AlgoTrading

export Bar
export LimitOrder, MarketOrder
export Transaction, OrdersStatus
export ==, +, -, *, /
export PerTrade, PerValue, PerVolume, commission
export AbstractAsset, Currency, Cash, Stock, FXPair, FXForward
export Quote, StockQuote, FXQuote, FXForwardQuote
export valcurrency, maturity, asset, domestic, foreign, invpair, invforward
export USD, JPY, CNY, EUR
export USDJPY, USDCNY, JPYUSD, CNYUSD, JPYCNY, CNYJPY

include("mktdatas.jl")
include("orders.jl")
include("transactions.jl")
include("assets/assets.jl")
include("commissions.jl")

end
