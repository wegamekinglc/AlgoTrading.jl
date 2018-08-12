using Test

@testset "FX quote test" begin
    timestamp = now()
    pair = FXPair(USD, JPY)
    fxquote = FXQuote(pair, 106., timestamp)

    @test tradetime(fxquote) == timestamp
    @test symbol(fxquote) == "USDJPY"
    @test asset(fxquote) == pair
    @test fxquote.value == 106.
    @test asset(fxquote) == pair
end

@testset "FX quote arithmetic test" begin
    timestamp = now()
    fxquote1 = FXQuote(USDJPY, 106., timestamp)
    fxquote2 = FXQuote(FXPair(CNY, JPY), 18., timestamp)

    converted = fxquote1 / fxquote2
    @test asset(converted) == USDCNY
    @test converted.value == fxquote1.value / fxquote2.value

    fxquote3 = 1. / fxquote2
    @test asset(fxquote3) == JPYCNY
    @test fxquote3.value == 1. / fxquote2.value

    converted = fxquote1 * fxquote3
    @test asset(converted) == USDCNY
    @test converted.value == fxquote1.value * fxquote3.value
end

@testset "Cash and fx quote arithmetic test" begin
    timestamp = now()
    fxquote = FXQuote(USDJPY, 106., timestamp)
    cash = Cash(USD, 100.)

    converted = cash * fxquote
    @test converted.currency == JPY
    @test converted.value == fxquote.value * cash.value

    converted = fxquote * cash
    @test converted.currency == JPY
    @test converted.value == fxquote.value * cash.value

    fxquote = FXQuote(JPYUSD, 0.01, timestamp)
    @test_throws ErrorException fxquote * cash
end
