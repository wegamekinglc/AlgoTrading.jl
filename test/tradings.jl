using Base.Test

@testset "Trading with positive amount test" begin
    timestamp = now()
    fxquote = FXQuote(USDCNY, 6.70, timestamp)
    comms = PerValue(0.005)
    amount = 2.25

    fcurr, dcurr, comm = trade(fxquote, amount, comms)
    @test fcurr.currency == USD
    @test fcurr.value == amount
    @test dcurr.currency == CNY
    @test dcurr.value ≈ -amount * fxquote.value
    @test comm.currency == CNY
    @test comm.value ≈ -comms.value * amount * fxquote.value

    comms = PerTrade(0.001)
    fcurr, dcurr, comm = trade(fxquote, amount, comms)
    @test comm.currency == CNY
    @test comm.value ≈ -comms.value

    comms = PerVolume(0.005)
    fcurr, dcurr, comm = trade(fxquote, amount, comms)
    @test comm.currency == USD
    @test comm.value ≈ -comms.value * amount
end


@testset "Trading with negative amount tes" begin
    timestamp = now()
    fxquote = FXQuote(USDCNY, 6.70, timestamp)
    comms = PerValue(0.005)
    amount = -2.25

    fcurr, dcurr, comm = trade(fxquote, amount, comms)
    @test fcurr.currency == USD
    @test fcurr.value == amount
    @test dcurr.currency == CNY
    @test dcurr.value ≈ -amount * fxquote.value
    @test comm.currency == CNY
    @test comm.value ≈ comms.value * amount * fxquote.value

    comms = PerTrade(0.001)
    fcurr, dcurr, comm = trade(fxquote, amount, comms)
    @test comm.currency == CNY
    @test comm.value ≈ -comms.value

    comms = PerVolume(0.005)
    fcurr, dcurr, comm = trade(fxquote, amount, comms)
    @test comm.currency == USD
    @test comm.value ≈ comms.value * amount
end
