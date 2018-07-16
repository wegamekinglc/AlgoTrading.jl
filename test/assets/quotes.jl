using Base.Test

include("../../src/assets/quotes.jl")

@testset "FX quote test" begin
    pair = FXPair(USD, JPY)
    fxquote = FXQuote(pair, 106.)
    @test asset(fxquote) == pair
    @test fxquote.value == 106.
    @test asset(fxquote) == pair
end

@testset "FX quote arithmetic test" begin
    fxquote1 = FXQuote(USDJPY, 106.)
    fxquote2 = FXQuote(FXPair(CNY, JPY), 18.)

    converted = fxquote1 / fxquote2
    @test asset(converted).symbol == "USD|CNY"
    @test converted.value == fxquote1.value / fxquote2.value

    fxquote3 = 1. / fxquote2
    @test asset(fxquote3).symbol == "JPY|CNY"
    @test fxquote3.value == 1. / fxquote2.value

    converted = fxquote1 * fxquote3
    @test asset(converted).symbol == "USD|CNY"
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
