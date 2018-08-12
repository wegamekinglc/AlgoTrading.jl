using Test

@testset "Per-value commissions test" begin
    timestamp = now()
    pervalue = PerValue(0.005)
    stock = Stock("600000.XSHG", CNY)
    stockquote = StockQuote(stock, 9.39, timestamp)
    amount = 2.

    comm = commission(stockquote, amount, pervalue)
    @test isa(comm, Cash)
    @test valcurrency(comm) == CNY
    @test comm.value == -amount * stockquote.value * pervalue.value

    fxpair = FXPair(USD, CNY)
    fxquote = FXQuote(fxpair, 6.6758, timestamp)
    comm = commission(fxquote, amount, pervalue)
    @test isa(comm, Cash)
    @test valcurrency(comm) == CNY
    @test comm.value == -amount * fxquote.value * pervalue.value
end

@testset "Per-trade commission test" begin
    timestamp = now()
    pertrade = PerTrade(0.005)
    stock = Stock("600000.XSHG", CNY)
    stockquote = StockQuote(stock, 9.39, timestamp)
    amount = 2.

    comm = commission(stockquote, amount, pertrade)
    @test isa(comm, Cash)
    @test valcurrency(comm) == CNY
    @test comm.value == -pertrade.value

    fxpair = FXPair(USD, CNY)
    fxquote = FXQuote(fxpair, 6.6758, timestamp)
    comm = commission(fxquote, amount, pertrade)
    @test isa(comm, Cash)
    @test valcurrency(comm) == CNY
    @test comm.value == -pertrade.value
end

@testset "Per-volume commission test" begin
    timestamp = now()
    pervolume = PerVolume(0.005)
    fxpair = FXPair(USD, CNY)
    fxquote = FXQuote(fxpair, 6.6758, timestamp)
    amount = 2.

    comm = commission(fxquote, amount, pervolume)
    @test isa(comm, Cash)
    @test valcurrency(comm) == USD
    @test comm.value == -amount * pervolume.value
end
