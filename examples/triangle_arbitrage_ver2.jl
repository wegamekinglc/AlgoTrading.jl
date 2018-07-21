include("../src/AlgoTrading.jl")

using AlgoTrading

include("utilities.jl")

using CSV

using DataFrames
using Base.DateTime

close_table = CSV.read("d:/binance_eos_eth_pivot.csv")
close_table[:trade_time] =
    map((x::String) -> DateTime(x, "yyyy-mm-dd HH:MM:SS"), close_table[:trade_time])

currencies = ["ETH", "EOS", "USDT"]

cols = [string(currencies[1], "|", currencies[3]),
        string(currencies[2], "|", currencies[3]),
        string(currencies[2], "|", currencies[1])]
n, m = size(close_table)

amount = 500.

for bps in [0, 5, 7, 10, 12]
    pervolume = PerVolume(bps / 10000)
    initial = Dict(currencies[1] => Cash(Currency(currencies[1]), 0.),
                   currencies[2] => Cash(Currency(currencies[2]), 0.),
                   currencies[3] => Cash(Currency(currencies[3]), amount))
    balance = Balance(initial)
    portfolio = DataFrame(:trade_time => close_table[:trade_time],
                          Symbol(currencies[1]) => zeros(n),
                          Symbol(currencies[2]) => zeros(n),
                          Symbol(currencies[3]) => zeros(n),
                          :turn_over => zeros(n))
    cash_names = names(portfolio)[2:end]

    for i in 1:n
        row = close_table[i, :]
        tradetime = row[:trade_time][1]
        quote1 = FXQuote(FXPair(cols[1]), row[Symbol(cols[1])][1], tradetime)
        quote2 = FXQuote(FXPair(cols[2]), row[Symbol(cols[2])][1], tradetime)
        quote3 = FXQuote(FXPair(cols[3]), row[Symbol(cols[3])][1], tradetime)

        quote1 = FXQuote(FXPair(cols[1]), row[Symbol(cols[1])][1], tradetime)
        quote2 = FXQuote(FXPair(cols[2]), row[Symbol(cols[2])][1], tradetime)
        quote3 = FXQuote(FXPair(cols[3]), row[Symbol(cols[3])][1], tradetime)

        arbitrage = (quote1 / quote2 * quote3).value
        current_foreign_notional = getbalance(balance, string(cash_names[2])) * quote2
        current_domestic_notional = getbalance(balance, string(cash_names[1])) * quote1

        target_foreign_notional = Cash(Currency(currencies[3]), amount) * (arbitrage - 1.)
        target_demestic_notional = -target_foreign_notional

        # trading part
        foreign_notional_diff = target_foreign_notional - current_foreign_notional
        if foreign_notional_diff.value >= 0.
            incash1, outcash1, comm1 = buy(quote2, foreign_notional_diff.value / quote2.value, pervolume)
        elseif foreign_notional_diff.value < 0.
            incash1, outcash1, comm1 = sell(quote2, -foreign_notional_diff.value / quote2.value, pervolume)
        end

        domestci_notional_diff = -foreign_notional_diff
        if domestci_notional_diff.value >= 0.
            incash2, outcash2, comm2 = buy(quote1, domestci_notional_diff.value / quote1.value, pervolume)
        elseif domestci_notional_diff.value < 0.
            incash2, outcash2, comm2 = sell(quote1, -domestci_notional_diff.value / quote1.value, pervolume)
        end

        incashes = [incash1, incash2]
        outcashes = [outcash1, outcash2]
        comms = [comm1, comm2]
        updatebalance!(balance, incashes, outcashes, comms)

        for k in 1:length(cols)
            portfolio[i, Symbol(cash_names[k])] = getbalance(balance,
                                                             string(cash_names[k])).value
            portfolio[i, :turn_over] = abs(foreign_notional_diff.value) / amount
        end
    end

    for name in cols[1:end]
        portfolio[Symbol(name)] = close_table[Symbol(name)]
    end

    CSV.write("d:/arb_$(bps)bps.csv", portfolio, dateformat="yyyy-mm-dd HH:MM:SS")
end
