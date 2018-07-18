using Base.Test

@testset "Trading with buy test" begin
    fxquote = FXQuote(USDCNY, 6.70)
    comm = PerValue(0.005)
    amount = 2.25

    incash, outcash, commcash = buy(fxquote, amount, comm)
    @test incash.currency == USD
    @test incash.value == amount
    @test outcash.currency == CNY
    @test outcash.value ≈ -amount * fxquote.value
    @test commcash.currency == CNY
    @test_approx_eq(commcash.value, comm.value * amount * fxquote.value)

    comm = PerTrade(0.001)
    incash, outcash, commcash = buy(fxquote, amount, comm)
    @test commcash.currency == CNY
    @test commcash.value ≈ comm.value

    comm = PerVolume(0.005)
    incash, outcash, commcash = buy(fxquote, amount, comm)
    @test commcash.currency == USD
    @test commcash.value ≈ comm.value * amount
end


@testset "Trading with sell test" begin
    fxquote = FXQuote(USDCNY, 6.70)
    comm = PerValue(0.005)
    amount = 2.25

    incash, outcash, commcash = sell(fxquote, amount, comm)
    @test outcash.currency == USD
    @test outcash.value == -amount
    @test incash.currency == CNY
    @test_approx_eq(incash.value, amount * fxquote.value)
    @test commcash.currency == CNY
    @test_approx_eq(commcash.value, comm.value * amount * fxquote.value)

    comm = PerTrade(0.001)
    incash, outcash, commcash = sell(fxquote, amount, comm)
    @test commcash.currency == CNY
    @test_approx_eq(commcash.value, comm.value)

    comm = PerVolume(0.005)
    incash, outcash, commcash = sell(fxquote, amount, comm)
    @test commcash.currency == USD
    @test_approx_eq(commcash.value, comm.value * amount)
end
