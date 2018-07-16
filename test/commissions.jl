using Base.Test

@testset "Per-value commissions test" begin
    pervalue = PerValue(0.005)
    stock = Stock("600000.XSHG", CNY)
    stockquote = StockQuote(stock, 9.39)

    comm = calcommission(stockquote, pervalue)
    @test isa(comm, Cash)
    @test valcurrency(comm) == CNY
    @test comm.value == stockquote.value * pervalue.value

    fxpair = FXPair(USD, CNY)
    fxquote = FXQuote(fxpair, 6.6758)
    comm = calcommission(fxquote, pervalue)
    @test isa(comm, Cash)
    @test valcurrency(comm) == CNY
    @test comm.value == fxquote.value * pervalue.value
end

@testset "Per-trade commission test" begin
    pertrade = PerTrade(0.005)
    stock = Stock("600000.XSHG", CNY)
    stockquote = StockQuote(stock, 9.39)

    comm = calcommission(stockquote, pertrade)
    @test isa(comm, Cash)
    @test valcurrency(comm) == CNY
    @test comm.value == pertrade.value

    fxpair = FXPair(USD, CNY)
    fxquote = FXQuote(fxpair, 6.6758)
    comm = calcommission(fxquote, pertrade)
    @test isa(comm, Cash)
    @test valcurrency(comm) == CNY
    @test comm.value == pertrade.value
end
