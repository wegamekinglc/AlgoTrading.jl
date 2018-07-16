using Base.Test

include("../../src/assets/fxs.jl")

@testset "FX pair test" begin
    fcurr = Currency("USD")
    dcurr = Currency("JPY")
    pair = FXPair(fcurr, dcurr)
    @test pair.symbol == "USD|JPY"
    @test pair.foreign == fcurr
    @test pair.domestic == dcurr

    pair2 = FXPair("USD|JPY")
    @test pair2.symbol == pair.symbol
    @test pair2.foreign == pair.foreign
    @test pair2.domestic == pair.domestic

    pair3 = invpair(pair)
    @test pair3.symbol == "JPY|USD"
    @test pair3.foreign == pair.domestic
    @test pair3.domestic == pair.foreign
end
