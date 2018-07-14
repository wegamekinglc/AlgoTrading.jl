using Base.Test

include("../src/assets.jl")

@testset "Currency test" begin
    currency = Currency("USD")
    @test currency.symbol == "USD"
end

@testset "Cash test" begin
    currency = Currency("USD")
    cash = Cash(currency, 100.)
    @test cash.currency == currency
    @test cash.value == 100.
end

@testset "Cash arithmetic test" begin
    curr1 = Currency("USD")
    cash1 = Cash(curr1, 100.)
    cash2 = Cash(curr1, 200.)

    total_cash = cash1 + cash2
    @test total_cash.currency == curr1
    @test total_cash.value == 300.

    total_cash = cash1 - cash2
    @test total_cash.currency == curr1
    @test total_cash.value == -100.

    total_cash = cash1 * 2.
    @test total_cash.currency == curr1
    @test total_cash.value == 200.

    total_cash = 2. * cash1
    @test total_cash.currency == curr1
    @test total_cash.value == 200.

    curr2 = Currency("JPY")
    cash3 = Cash(curr2, 200.)
    @test_throws ErrorException cash1 + cash3
    @test_throws ErrorException cash1 - cash3
end

@testset "FX pair test" begin
    foreign = Currency("USD")
    domestic = Currency("JPY")
    pair = FXPair(foreign, domestic)
    @test pair.symbol == "USD|JPY"
    @test pair.foreign == foreign
    @test pair.domestic == domestic

    pair2 = FXPair("USD|JPY")
    @test pair2.symbol == pair.symbol
    @test pair2.foreign == pair.foreign
    @test pair2.domestic == pair.domestic

    pair3 = invpair(pair)
    @test pair3.symbol == "JPY|USD"
    @test pair3.foreign == pair.domestic
    @test pair3.domestic == pair.foreign
end

@testset "FX quote test" begin
    pair = FXPair(USD, JPY)
    fxquote = FXQuote(pair, 106.)
    @test fxquote.pair == pair
    @test fxquote.value == 106.
    @test fxpair(fxquote) == pair
end

@testset "FX quote arithmetic test" begin
    fxquote1 = FXQuote(USDJPY, 106.)
    fxquote2 = FXQuote(FXPair(CNY, JPY), 18.)

    converted = fxquote1 / fxquote2
    @test converted.pair.symbol == "USD|CNY"
    @test converted.value == fxquote1.value / fxquote2.value

    fxquote3 = 1. / fxquote2
    @test fxquote3.pair.symbol == "JPY|CNY"
    @test fxquote3.value == 1. / fxquote2.value

    converted = fxquote1 * fxquote3
    @test converted.pair.symbol == "USD|CNY"
    @test converted.value == fxquote1.value * fxquote3.value
end

@testset "Cash and fx quote arithmetic test" begin
    fxquote = FXQuote(USDJPY, 106.)
    cash = Cash(USD, 100.)

    converted = cash * fxquote
    @test converted.currency == JPY
    @test converted.value == fxquote.value * cash.value

    converted = fxquote * cash
    @test converted.currency == JPY
    @test converted.value == fxquote.value * cash.value

    fxquote = FXQuote(JPYUSD, 0.01)
    @test_throws ErrorException fxquote * cash
end
