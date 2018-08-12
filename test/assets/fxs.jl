using Test
using Dates

@testset "FX pair test" begin
    fcurr = Currency("USD")
    dcurr = Currency("JPY")
    pair = FXPair(fcurr, dcurr)
    @test symbol(pair) == "USDJPY"
    @test pair.foreign == fcurr
    @test pair.domestic == dcurr

    pair2 = FXPair("USD|JPY")
    @test pair2.foreign == pair.foreign
    @test pair2.domestic == pair.domestic

    pair3 = invpair(pair)
    @test pair3.foreign == pair.domestic
    @test pair3.domestic == pair.foreign
end

@testset "FX forward test" begin
    pair = FXPair(USD, JPY)
    ttm = DateTime(2018, 7, 9, 16, 0, 0)
    forward = FXForward(pair, ttm)

    @test symbol(forward) == "USDJPY_201807091600"
    @test forward.pair == pair
    @test maturity(forward) == ttm

    forward2 = invforward(forward)
    @test forward2.pair == invpair(pair)
    @test maturity(forward2) == ttm

    forward3 = FXForward(pair, ttm)
    @test forward3 == forward
end
