using Base.Test

include("../../src/assets/base.jl")

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
