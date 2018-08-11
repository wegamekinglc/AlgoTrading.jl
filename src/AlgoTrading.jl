module AlgoTrading

export Bar
export LimitOrder, MarketOrder
export Transaction, OrdersStatus
export ==, +, -, *, /
export PerTrade, PerValue, PerVolume, commission
export AbstractAsset, Currency, Cash, Stock, FXPair, FXForward
export Quote, StockQuote, FXQuote, FXForwardQuote
export tradetime, symbol, valcurrency, maturity, asset, domestic, foreign, invpair, invforward
export USD, JPY, CNY, EUR
export BTC, ETH, EOS, USDT
export USDJPY, USDCNY, JPYUSD, CNYUSD, JPYCNY, CNYJPY
export BTCUSD, ETHUSD, EOSUSD, BTCUSDT, ETHUSDT, EOSUSDT, EOSBTC, EOSETH
export trade
export Balance, update, update!, getbalance

include("mktdatas.jl")
include("orders.jl")
include("transactions.jl")
include("assets/assets.jl")
include("commissions.jl")
include("portfolios.jl")
include("tradings.jl")
include("datas/okex.jl")

end
