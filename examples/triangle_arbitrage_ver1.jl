include("../src/AlgoTrading.jl")

using AlgoTrading
using CSV
using Iterators
using DataFrames
using Base.DateTime

close_table = CSV.read("d:/binance_eos_eth_pivot.csv")
close_table[:trade_time] =
    map((x::String) -> DateTime(x, "yyyy-mm-dd HH:MM:SS"), close_table[:trade_time])

currencies = ["ETH", "EOS", "USDT"]
cashsymbols = [Symbol(c) for c in currencies]

cols = [string(currencies[1], "|", currencies[3]),
        string(currencies[2], "|", currencies[3]),
        string(currencies[2], "|", currencies[1])]

fxpairs = [FXPair(c) for c in cols]
quotesymbols = [Symbol(c) for c in cols]

n, m = size(close_table)
amount = 500.

@time for bps in [5, 7, 10, 12]
    pervolume = PerVolume(bps / 10000.)
    pervalue = PerValue(bps / 10000.)

    initial = Dict(currencies[1] => Cash(Currency(currencies[1]), 0.),
                   currencies[2] => Cash(Currency(currencies[2]), 0.),
                   currencies[3] => Cash(Currency(currencies[3]), amount))

    balance = Balance(initial)
    portfolio = DataFrame(:trade_time => close_table[:, 1],
                          cashsymbols[1] => zeros(n),
                          cashsymbols[2] => zeros(n),
                          cashsymbols[3] => zeros(n),
                          :turn_over => zeros(n),
                          quotesymbols[1] => close_table[quotesymbols[1]],
                          quotesymbols[2] => close_table[quotesymbols[2]],
                          quotesymbols[3] => close_table[quotesymbols[3]])

    for i in 1:n
        tradetime = close_table[i, :trade_time]
        quote1 = FXQuote(fxpairs[1], close_table[i, quotesymbols[1]], tradetime)
        quote2 = FXQuote(fxpairs[2], close_table[i, quotesymbols[2]], tradetime)
        quote3 = FXQuote(fxpairs[3], close_table[i, quotesymbols[3]], tradetime)

        arbitrage = (quote1 / quote2 * quote3).value - 1.
        direction = sign(arbitrage)

        if abs(arbitrage) > .003
            # 正向套利机会
            fcurr1, dcurr1, comm1 = trade(quote3, -direction * amount / quote2.value, pervolume)
            fcurr2, dcurr2, comm2 = trade(quote1, -dcurr1.value, pervalue)
            fcurr3, dcurr3, comm3 = trade(quote2, -fcurr1.value - comm1.value, pervalue)
            update!(balance, [fcurr1, dcurr1, comm1, fcurr2, dcurr2, comm2, fcurr3, dcurr3, comm3])
            portfolio[i, :turn_over] = 1.
        end

        for s in cashsymbols
            portfolio[i, s] = getbalance(balance, string(s)).value
        end
    end
    CSV.write("d:/arb_$(bps)bps.csv", portfolio, dateformat="yyyy-mm-dd HH:MM:SS")
end
