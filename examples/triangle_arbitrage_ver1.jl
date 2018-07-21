include("../src/AlgoTrading.jl")
include("utilities.jl")

using CSV
using AlgoTrading
using DataFrames
using Base.DateTime

close_table = CSV.read("d:/binance_eos_btc_pivot.csv")
close_table[:trade_time] =
    map((x::String) -> DateTime(x, "yyyy-mm-dd HH:MM:SS"), close_table[:trade_time])

currencies = ["BTC", "EOS", "USDT"]

cols = [string(currencies[1], "|", currencies[3]),
        string(currencies[2], "|", currencies[3]),
        string(currencies[2], "|", currencies[1])]

n, m = size(close_table)

for bps in [5, 7, 10, 12]

    tradecounts = 0
    pervolume = PerVolume(bps / 10000.)
    pervalue = PerValue(bps / 10000.)
    amount = 500.

    initial = Dict(currencies[1] => Cash(Currency(currencies[1]), 0.),
                   currencies[2] => Cash(Currency(currencies[2]), 0.),
                   currencies[3] => Cash(Currency(currencies[3]), amount))

    balance = Balance(initial)
    portfolio = DataFrame(:trade_time => close_table[:trade_time],
                          Symbol(currencies[1]) => zeros(n),
                          Symbol(currencies[2]) => zeros(n),
                          Symbol(currencies[3]) => zeros(n))
    cash_names = names(portfolio)[2:end]

    @time @parallel for i in 1:n
        row = close_table[i, :]
        tradetime = row[:trade_time][1]
        quote1 = FXQuote(FXPair(cols[1]), row[Symbol(cols[1])][1], tradetime)
        quote2 = FXQuote(FXPair(cols[2]), row[Symbol(cols[2])][1], tradetime)
        quote3 = FXQuote(FXPair(cols[3]), row[Symbol(cols[3])][1], tradetime)

        arbitrage = quote1 / quote2 * quote3

        if arbitrage.value > 1.003
            # 正向套利机会
            tradecounts += 1
            incash1, outcash1, comm1 = sell(quote3, amount / quote2.value, pervolume)
            incash2, outcash2, comm2 = sell(quote1, incash1.value, pervalue)
            incash3, outcash3, comm3 = buy(quote2, -outcash1.value + comm1.value, pervalue)
            incashes = [incash1, incash2, incash3]
            outcashes = [outcash1, outcash2, outcash3]
            comms = [comm1, comm2, comm3]
            updatebalance!(balance, incashes, outcashes, comms)
        elseif arbitrage.value < 0.997
            # 反向套利机会
            tradecounts += 1
            incash1, outcash1, comm1 = buy(quote3, amount / quote2.value, pervolume)
            incash2, outcash2, comm2 = buy(quote1, -outcash1.value, pervalue)
            incash3, outcash3, comm3 = sell(quote2, incash1.value - comm1.value, pervalue)
            incashes = [incash1, incash2, incash3]
            outcashes = [outcash1, outcash2, outcash3]
            comms = [comm1, comm2, comm3]
            updatebalance!(balance, incashes, outcashes, comms)
        end

        for k in 1:length(cols)
            portfolio[i, Symbol(cash_names[k])] = getbalance(balance,
                                                             string(cash_names[k])).value
        end
    end

    for name in cols[1:end-1]
        portfolio[Symbol(name)] = close_table[Symbol(name)]
    end
    println(tradecounts)
    CSV.write("d:/arb_$(bps)bps.csv", portfolio, dateformat="yyyy-mm-dd HH:MM:SS")
end